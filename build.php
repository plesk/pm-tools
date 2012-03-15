#!/usr/bin/env php
<?php

$packageDir = @$argv[1];

if (!$packageDir) {
    echo "Need to specify package directory.\n";
    exit(1);
}

if (!is_dir($packageDir)) {
    echo "Directory $packageDir is not found.\n";
    exit(2);
}

$packageDir = basename($packageDir);
echo "Package directory: $packageDir\n";

$xml = simplexml_load_file("$packageDir/meta.xml");

$packageName = (string)$xml->id;
$zipName = "$packageName-{$xml->version}-{$xml->release}.zip";
echo "Package name: $packageName\n";
echo "Archive name: $zipName\n";

`cd $packageDir/ ; zip -r $zipName ./ -x "./.git/*"`;
`mv $packageDir/$zipName ./`;

echo "Done.\n";
