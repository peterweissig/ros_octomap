#!/bin/sh

###############################################################################
#                                                                             #
# Makefile                                                                    #
# ========                                                                    #
#                                                                             #
###############################################################################
#                                                                             #
# github repository                                                           #
#   https://github.com/peterweissig/ros_octomap                               #
#                                                                             #
# Chair of Automation Technology, Technische Universität Chemnitz             #
#   https://www.tu-chemnitz.de/etit/proaut                                    #
#                                                                             #
###############################################################################
#                                                                             #
# New BSD License                                                             #
#                                                                             #
# Copyright (c) 2015-2016, Peter Weissig, Technische Universität Chemnitz     #
# All rights reserved.                                                        #
#                                                                             #
# Redistribution and use in source and binary forms, with or without          #
# modification, are permitted provided that the following conditions are met: #
#     * Redistributions of source code must retain the above copyright        #
#       notice, this list of conditions and the following disclaimer.         #
#     * Redistributions in binary form must reproduce the above copyright     #
#       notice, this list of conditions and the following disclaimer in the   #
#       documentation and/or other materials provided with the distribution.  #
#     * Neither the name of the Technische Universität Chemnitz nor the       #
#       names of its contributors may be used to endorse or promote products  #
#       derived from this software without specific prior written permission. #
#                                                                             #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" #
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   #
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  #
# ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY      #
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES  #
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR          #
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER  #
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT          #
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY   #
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH #
# DAMAGE.                                                                     #
#                                                                             #
###############################################################################

NAME_GIT_THIS="octomap"
NAME_GIT_SUBS="parameter"

###############################################################################
URL_GIT_BASE="https://github.com/peterweissig/"
URL_GIT_THIS="${URL_GIT_BASE}ros_${NAME_GIT_THIS}.git"
DIR_THIS="${NAME_GIT_THIS}_pa/"

NAME_CHECKOUT_SCRIPT="checkout.sh"
NAME_ARGUMENT_SCRIPT="dependency"

###############################################################################
if [ "$#" -eq 0 ]; then
    echo "Running this script without parameters."
    echo "Therefore the project"
    echo "  \"${NAME_GIT_THIS}\""
    echo "will be checked out completely."
    echo ""

    PATH_CURRENT="$(pwd)/"

    mkdir -p "${PATH_CURRENT}${DIR_THIS}"
    cd "${PATH_CURRENT}${DIR_THIS}"

    if [ -d ".git" ]; then
        echo "This folder already is a git-repository!"
        return
    fi
    git init
    git pull "${URL_GIT_THIS}"
    if [ $? -ne 0 ]; then return; fi

    echo ""
    echo "### checking out additional source code"
    if [ ! -f "${NAME_CHECKOUT_SCRIPT}" ]; then
        echo "Error - no checkout script"
        return
    fi

    sh "${NAME_CHECKOUT_SCRIPT}" "${NAME_ARGUMENT_SCRIPT}"
    if [ $? -ne 0 ]; then return; fi

    echo ""
    echo "### deleting this script"
    cd "${PATH_CURRENT}"
    rm "${NAME_CHECKOUT_SCRIPT}"

###############################################################################
elif [ "$1" = "${NAME_ARGUMENT_SCRIPT}" ]; then
    echo "Running this script with argument \"$1\"."
    echo "Therefore all dependend sources of"
    echo "  \"${NAME_GIT_THIS}\""
    echo "will be checked out recursivly."
    echo ""

    SRC_DIR_DEPENDENCY="$(pwd)"

    for dependency in $NAME_GIT_SUBS ; do
        cd "${SRC_DIR_DEPENDENCY}"

        DIR_DEPENDENCY="${dependency}_pa/"

        if [ ! -d "../${dependency}" ]; then
            echo ""
            echo "### checking out ${dependency}"
            mkdir -p "../${dependency}"
            cd "../${dependency}"

            URL="${URL_GIT_BASE}cpp_${dependency}.git"
            git init
            git pull "${URL}"

            if [ -f "checkout.sh" ]; then
                sh "${NAME_CHECKOUT_SCRIPT}" "${NAME_ARGUMENT_SCRIPT}"
            fi
        fi
    done

###############################################################################
else
    echo "Running this script with argument \"$1\"."
    echo "Error - expecting no argument or \"${NAME_ARGUMENT_SCRIPT}\"."
    return
fi