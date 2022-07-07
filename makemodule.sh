#!/bin/bash

checkOrCreateDirectory () {
  if [ ! -d "$DIR" ]; then
    ### Take action if $DIR doesn't exists ###
    echo "$DIR directory created."
    mkdir "$DIR"
  fi
}

checkIfModuleAlreadyExists () {
  if [ -d "$DIR" ]; then
    echo "Error: module \"$VENDOR/$MODULE\" already exists."
    exit 1
  fi
}

VENDOR="VendorName"
MODULE="ModuleName"
CONTROLLER="ControllerName"
ACTION="ActionName"

DIR="./app"
checkOrCreateDirectory

DIR="./app/code"
checkOrCreateDirectory

DIR="./app/code/$VENDOR"
checkOrCreateDirectory

DIR="./app/code/$VENDOR/$MODULE"
checkIfModuleAlreadyExists

mkdir "./app/code/$VENDOR/$MODULE"
mkdir "./app/code/$VENDOR/$MODULE/Block"
mkdir "./app/code/$VENDOR/$MODULE/Controller"
mkdir "./app/code/$VENDOR/$MODULE/Controller/$CONTROLLER"
mkdir "./app/code/$VENDOR/$MODULE/etc"
mkdir "./app/code/$VENDOR/$MODULE/etc/frontend"
mkdir "./app/code/$VENDOR/$MODULE/etc/frontend/layout"
mkdir "./app/code/$VENDOR/$MODULE/etc/frontend/templates"
mkdir "./app/code/$VENDOR/$MODULE/etc/frontend/web"
mkdir "./app/code/$VENDOR/$MODULE/etc/frontend/web/css"

## CREATE REGISTRATION.PHP 
FILE="./app/code/$VENDOR/$MODULE/registration.php"
touch "$FILE"
echo " <?php
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */

use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    '$VENDOR_$MODULE',
    __DIR__
);" > "$FILE"

## CREATE ACTION FILE
FILE="./app/code/$VENDOR/$MODULE/Controller/$CONTROLLER/$ACTION.php"
touch "$FILE"
echo "<?php

namespace $VENDOR\\$MODULE\Controller\\$CONTROLLER;

class $ACTION extends \Magento\Framework\App\Action\Action {

  protected \$_pageFactory;

  public function __construct(
    \Magento\Framework\App\Action\Context \$context,
    \Magento\Framework\View\Result\PageFactory \$pageFactory) {
    parent::__construct(\$context);
    \$this->_pageFactory = \$pageFactory;
  }

  public function execute() {
    return \$this->_pageFactory->create();
  }

}" > "$FILE"

## CREATE ROUTES.XML

# to do: how to lowercase all vendor and module names to set route id
# `tr [:lower:] <<<$VENDOR` ???

FILE="./app/code/$VENDOR/$MODULE/etc/frontend/routes.xml"
touch "$FILE"
echo "<?xml version="1.0"?>
<!--
/**
 * Copyright © Magento, Inc. All rights reserved.
 * * See COPYING.txt for license details.
 */
-->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:App/etc/routes.xsd">
    <router id="standard">
        <route id="idname" frontName="slugname">
            <module name="$VENDOR_$MODULE" />
        </route>
    </router>
</config>
" > "$FILE"
