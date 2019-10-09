# SearchLongMethodNamesInJavaFilesOfProjectDirectories

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-red.svg)](https://www.gnu.org/software/bash/)
![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)
![GitHub stars](https://img.shields.io/github/stars/lell170/searchLongMethodNamesInJavaFilesOfProjectDirectories?color=yellow)

Simple bash script to recognize long method names in java source files 

![](searchLongMethodNamesInJavaFilesOfProjectDirectories.gif)

## Getting started
### Installation
1. Clone the repo 
    ```sh
    $ git clone https://github.com/lell170/searchLongMethodNamesInJavaFilesOfProjectDirectories.git
    ```
2. Change into cloned directory
    ```sh
    $ cd searchLongMethodNamesInJavaFilesOfProjectDirectories
    ```
3. Make script executable
    ```sh
    $ chmod +x longmethods.sh
    ```
4. Add to path
    ```sh
    $ sudo mv longmethods.sh /usr/local/bin/longmethods (move to bin path without *.sh)
    ```   
## Usage 
    longmethods <path to java project directory> <number of max results>

## Licence
Distributed under the MIT License. See `LICENSE` for more information.
