# SearchLongMethodNamesInJavaFilesOfProjectDirectories

![GitHub stars](https://img.shields.io/github/stars/lell170/searchLongMethodNamesInJavaFilesOfProjectDirectories?color=yellow)
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-red.svg)](https://www.gnu.org/software/bash/)
![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)

Simple bash script to recognize long method names in java source files 

![](searchLongMethodNamesInJavaFilesOfProjectDirectories.gif)

## Getting started
### Installation
1. Clone the repo 
    ```bash
    $ git clone https://github.com/lell170/searchLongMethodNamesInJavaFilesOfProjectDirectories.git
    ```
2. Change into cloned directory
    ```bash
    $ cd searchLongMethodNamesInJavaFilesOfProjectDirectories
    ```
3. Install repo by running installation script
    ```bash
    $ sudo sh -c 'chmod +x install.sh && ./install.sh'
    ```
   
## Usage 
    longmethods -d <path to java project directory>

## Options
    -d, --directory (*requiered option for project directory)
    -l, --limit (limit of results)
    -f, --isLongFrom ( (chars count) definition for a long method)

## Licence
Distributed under the MIT License. See `LICENSE` for more information.
