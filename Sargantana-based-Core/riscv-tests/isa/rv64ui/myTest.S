#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

TEST_CASE(1, x4, 0x0123456789abcdef, \
  la  x1, tdat;        \
  li x2, 0x0123456789abcdef; \
  sd x2, 0(x1);        \
  ld x4, 0(x1);        \
)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:

RVTEST_DATA_END
