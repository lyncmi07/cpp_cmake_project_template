//
// Created by Michael Lynch on 25/03/2021.
//

#include <auto_test.hpp>
#include <iostream>

TEST_SUITE(ExampleTests)
{
    TEST(0, shouldRemoveThisTest)
    {
        ASSERT_EQUALS("This test should be removed before starting the project", "")
    }
}
