// Copyright 2018 The MathWorks, Inc. 

// Include Files
#include "myAdd.h"
#include "main.h"
#include "myAdd_terminate.h"
#include "myAdd_initialize.h"
#include <stdio.h>

// Function Declarations
static void argInit_1x100_real_T(real_T result[100]);
static void main_myAdd();

// Function Definitions

//
// Arguments    : real_T result[100]
// Return Type  : void
//
static void argInit_1x100_real_T(real_T result[100])
{
  int32_T idx1;

  // Loop over the array to initialize each element.
  for (idx1 = 0; idx1 < 100; idx1++) {
    // Set the value of the array element.
    result[idx1] = (real_T) idx1;
  }
}

void writeToFile(real_T result[100])
{
    FILE *fid = NULL;
    fid = fopen("myAdd.bin", "wb");
    fwrite(result, sizeof(real_T), 100, fid);
    fclose(fid);
}

//
// Arguments    : void
// Return Type  : void
//
static void main_myAdd()
{
  real_T out[100];
  real_T b[100];
  real_T c[100];

  // Initialize function 'myAdd' input arguments.
  // Initialize function input argument 'inp1'.
  // Initialize function input argument 'inp2'.
  // Call the entry-point 'myAdd'.
  argInit_1x100_real_T(b);
  argInit_1x100_real_T(c);
  myAdd(b, c, out);
	
  // Write the output to a binary file
  writeToFile(out);
}

//
// Arguments    : int32_T argc
//                const char * const argv[]
// Return Type  : int32_T
//
int32_T main(int32_T, const char * const [])
{
  // Initialize the application.
  // You do not need to do this more than one time.
  myAdd_initialize();

  // Invoke the entry-point functions.
  // You can call entry-point functions multiple times.
  main_myAdd();

  // Terminate the application.
  // You do not need to do this more than one time.
  myAdd_terminate();
  return 0;
}

//
// File trailer for main.cu
//
// [EOF]
//
