#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

flutter test --coverage

genhtml coverage/lcov.info -o coverage/html
