from array import array
import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    # Focus:
    # 1. There should be both cases of array1[i] > array2[i] and array1[i] < array2[i].
    # 2. You should check the invalid length input.
    # 3. You should imitate the use of any function rightly from unittests.py.
    # 4. When you are writing other test and want to copy some other codes, 
    #    you should remember to modify the path of function AssemblyTest() and 
    #    the argument of t.call().
    # 5. Looking into the assembly code of initialize zero and you will find 
    #    you need both check the lower and upper boundary.

    def test_simple(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # raise NotImplementedError("TODO")

        # create array0 in the data section
        array0 = t.array([1, 2, 3, 4, 5])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([1, 3, 5, 7, 9])
        # load address of `array1` into register a1
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array0))
        # create a result array in the data section (fill values with -1)
        output_array = t.array([-1] * len(array0))
        # load address of `array2` into register a3
        t.input_array("a3", output_array)
        # call the `abs_loss` function
        t.call("abs_loss")
        # check that the result array contains the correct output
        t.check_array(output_array, [0, 1, 2, 3, 4])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 10)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary

    def test__length_1(self):
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        # create an array in the data section
        array0 = t.array([3])
        array1 = t.array([3])
        # load address of the array into register a0
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array0))
        # create a result array in the data section (fill values with -1)
        output_array = t.array([-1] * len(array0))
        # load address of `array2` into register a3
        t.input_array("a3", output_array)
        # call the `argmax` function
        t.call("abs_loss")
        # check that the result array contains the correct output
        t.check_array(output_array, [0])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    def test_complex(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # create array0 in the data section
        array0 = t.array([1, 2, 3, 4, 5, 11, 13, 15, 17, 19])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([1, 3, 5, 7, 9, 6, 7, 8, 9, 10])
        # load address of `array1` into register a1
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array0))
        # create a result array in the data section (fill values with -1)
        output_array = t.array([-1] * len(array0))
        # load address of `array2` into register a3
        t.input_array("a3", output_array)
        # call the `abs_loss` function
        t.call("abs_loss")
        # check that the result array contains the correct output
        t.check_array(output_array, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 45)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    def test_invalid_length(self):
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        array0 = t.array([1, 2, 3, 4, 5])
        t.input_array("a0", array0)
        array1 = t.array([1, 2, 3, 4, 5])
        t.input_array("a0", array1)
        t.input_scalar("a2", -5)
        output_array = t.array([-1] * len(array0))
        t.input_array("a3", output_array)
        t.call("abs_loss")
        t.execute(code=36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def test_simple(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # raise NotImplementedError("TODO")

        # create input arrays in the data section
        array0 = t.array([1, 2, 3, 7, 9])
        array1 = t.array([1, 3, 5, 4, 5])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array length into argument register
        t.input_scalar("a2", len(array0))
        # create a result array in the data section (fill values with -1)
        output_array = t.array([-1] * len(array0))
        # load result array address into argument register
        t.input_array("a3", output_array)
        # call the `squared_loss` function
        t.call("squared_loss")
        # check that the result array contains the correct output
        t.check_array(output_array, [0, 1, 4, 9, 16])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 30)
        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
    def test_invalid_length(self):
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        array0 = t.array([1, 2, 3, 4, 5])
        t.input_array("a0", array0)
        array1 = t.array([])
        t.input_scalar("a2", len(array1))
        output_array = t.array([-1] * len(array0))
        t.input_array("a3", output_array)
        t.call("squared_loss")
        t.execute(code=36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def test_simple(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # raise NotImplementedError("TODO")
# 
        # create input arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5])
        array1 = t.array([1, 3, 3, 7, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array length into argument register
        t.input_scalar("a2", len(array0))
        # create a result array in the data section (fill values with -1)
        output_array = t.array([-1] * len(array0))
        # load result array address into argument register
        t.input_array("a3", output_array)
        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        # check that the result array contains the correct output
        t.check_array(output_array, [1, 0, 1, 0, 0])
        # generate the `assembly/TestZeroOneLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
    def test_invalid_length(self):
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        array0 = t.array([1, 2, 3, 4, 5])
        t.input_array("a0", array0)
        array1 = t.array([1, 2, 3, 4, 5])
        t.input_scalar("a2", -1)
        output_array = t.array([-1] * len(array0))
        t.input_array("a3", output_array)
        t.call("zero_one_loss")
        t.execute(code=36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        # raise NotImplementedError("TODO")

        # input the length of the desired array
        t.input_scalar("a0", 5)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.check_array_pointer("a0", [0, 0, 0, 0, 0])
        t.execute()

    # Add other test cases if neccesary
    def test_invalid_n(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        # input the length of the desired array
        t.input_scalar("a0", 0x3f3f3f3f)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        t.execute(code = 26)

    def test_invalid_len(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        # input the length of the desired array
        t.input_scalar("a0", -1)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        t.execute(code = 36)

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
