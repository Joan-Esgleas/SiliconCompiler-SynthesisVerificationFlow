import os
import multiprocessing

from siliconcompiler import Design, Sim, ASIC, Flowgraph, Task, StdCellLibrary
from siliconcompiler.tools.openroad import OpenROADStdCellLibrary
from siliconcompiler.tools.sv2v.convert import ConvertTask
from siliconcompiler.tools.slang.elaborate import Elaborate
from siliconcompiler.tools.yosys.syn_asic import ASICSynthesis
from siliconcompiler.tools.verilator.compile import CompileTask
from siliconcompiler.tools.execute.exec_input import ExecInputTask
from siliconcompiler.flows.dvflow import DVFlow
from siliconcompiler.flows.asicflow import SV2VASICFlow
from siliconcompiler.targets import asic_target
from siliconcompiler.tools.verilator.compile import CompileTask
from siliconcompiler.utils.paths import workdir

from mem_generator import generate_sram_verilog_macro, DEFAULT_SRAM_CONFIGS, FAKERAM_BB_V

NANGATE45_CELLS_V = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'nangate45_cells.v')
FAKERAM_SIM_V = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fakeram45_32x32_sim.v')
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))

class SRAMMacroLib(OpenROADStdCellLibrary):
    def __init__(self, name, lef_path, lib_path):
        super().__init__()
        self.set_name(name)
        with self.active_fileset("models.physical"):
            self.add_file(lef_path)
            self.add_asic_aprfileset()
        with self.active_fileset("models.timing.nldm"):
            self.add_file(lib_path)
            self.add_asic_libcornerfileset("typical", "nldm")
        with self.active_fileset("openroad.powergrid"):
            self.add_file(os.path.join(PROJECT_DIR,"pdn_config.tcl"))
            self.add_openroad_powergridfileset()

class MemGenTask(Task):
    def __init__(self, configs=None):
        super().__init__()
        self._configs = configs if configs is not None else DEFAULT_SRAM_CONFIGS

    def tool(self):
        return "memory_generator"

    def task(self):
        return "generate"
    def setup(self):
        super().setup()
        for aw, dw in self._configs:
            self.add_output_file(f"sram_1p_a{aw}_d{dw}.sv")
        self.add_output_file("asic_sram_1p.v")
        self.add_output_file("top_tile.sv")
    def run(self):
        generate_sram_verilog_macro(config=self._configs, output_dir="outputs")
        self.logger.info("SRAM Verilog generation complete")
        return 0

class FakeramFullFlow(Flowgraph):
    def __init__(self, configs=None):
        super().__init__("fakeram_full_flow")

        self.node("generate_memory", MemGenTask(configs=configs))
        self.node("convert", ConvertTask())
        self.node("elaborate", Elaborate())
        self.node("synthesis", ASICSynthesis())
        self.node("gls_compile", CompileTask())
        self.node("gls_sim", ExecInputTask())

        self.edge("generate_memory", "convert")
        self.edge("convert", "elaborate")
        self.edge("elaborate", "synthesis")
        self.edge("synthesis", "gls_compile")
        self.edge("gls_compile", "gls_sim")

def main():
    pdk = "freepdk45"

    #Mem gen
    design = Design()
    design.set_name("fakeram_tile")
    with design.active_fileset("sources"):
        design.set_topmodule("top_tile")

    flow = Flowgraph("memgen_flow")
    flow.node("mem_gen", MemGenTask(configs=DEFAULT_SRAM_CONFIGS))

    project = Sim()
    project.set_design(design)
    project.add_fileset("sources")
    project.set('option', 'remote', False)
    project.set('option', 'jobname', 'sram_gen')
    project.set_flow(flow)

    project.run()
    project.summary()
    mem_gen_out = os.path.join(workdir(project, 'mem_gen', '0'), 'outputs')


    #Syntesis
    design = Design()
    
    design.set_name("fakeram_tile")
    
    with design.active_fileset("rtl"):
        design.set_topmodule("top_tile")
        design.add_file(FAKERAM_BB_V)
        for aw, dw in DEFAULT_SRAM_CONFIGS:
            design.add_file(os.path.join(mem_gen_out, f"sram_1p_a{aw}_d{dw}.sv"))
        design.add_file(os.path.join(mem_gen_out, "asic_sram_1p.v"))
        design.add_file(os.path.join(mem_gen_out, "top_tile.sv"))
    with design.active_fileset(f"sdc.{pdk}"):
        design.add_file(os.path.join(PROJECT_DIR, "fakeram_tile.sdc"))


    project = ASIC()
    project.set_design(design)
    project.add_fileset("rtl")
    project.add_fileset(f"sdc.{pdk}")
    Lib = SRAMMacroLib("fakeram45_32x32", os.path.join(PROJECT_DIR,"fakeram45_32x32.lef")
                                , os.path.join(PROJECT_DIR,"fakeram45_32x32.lib"))
    project.add_asiclib(Lib)

    project.set('option', 'remote', False)
    N = multiprocessing.cpu_count()
    project.set('option', 'scheduler', 'maxthreads', N)

    asic_target(project, pdk=pdk)
    project.set_flow(SV2VASICFlow())
    project.set('tool', 'slang', 'task', 'elaborate', 'warningoff',
                ['RangeOOB', 'RangeWidthOOB'])
    project.set('constraint', 'area', 'density', 4)
    project.set('option', 'to', ['synthesis'])

    project.run()
    project.summary()


    #Simulation
    design = Design()
    design.set_name("fakeram_tile")
    vg_path = project.find_result('vg', step='synthesis')
    with design.active_fileset("rtl"):
        design.set_topmodule("top_tile")
        design.add_file(NANGATE45_CELLS_V)
        design.add_file(FAKERAM_SIM_V)
        design.add_file(vg_path)
    with design.active_fileset("testbench.verilator"):
        design.set_topmodule("top_tile")
        design.add_file(os.path.join(PROJECT_DIR, "testbench.cc"))

    sim_project = Sim()
    sim_project.set_design(design)
    sim_project.add_fileset("testbench.verilator")
    sim_project.add_fileset("rtl")
    sim_project.set('option', 'jobname', 'gate_sim')
    sim_project.set_flow(DVFlow(tool="verilator"))
    CompileTask.find_task(sim_project).set_verilator_trace(True)

    sim_project.run()
    sim_project.summary()

    full_flow = FakeramFullFlow(configs=DEFAULT_SRAM_CONFIGS)
    flowgraph_path = os.path.join(PROJECT_DIR, "build", "fakeram_full_flow.svg")
    os.makedirs(os.path.join(PROJECT_DIR, "build"), exist_ok=True)
    full_flow.write_flowgraph(flowgraph_path, landscape=True)

if __name__ == '__main__':
    main()
