 Param(
 [Parameter(Mandatory=$true)]
 [string]$SiteUrl,
 [Parameter(Mandatory=$false)]
 [string]$XMLTermsFileName = "SiteColumns.xml",
 [string] $GroupToExport = "IPAColumns"
 )
 
 Set-Location $PSScriptRoot

 function LoadAndConnectToSharePoint($url)
 {

  ##Using PnP library
  Connect-SPOnline -Url $SiteUrl -CurrentCredentials
  $spContext =  Get-SPOContext
  return $spContext
}

$Context = LoadAndConnectToSharePoint  $SiteUrl

$SPOfields = Get-SPOField

$PathToExportXMLSiteColumns = $PSScriptRoot
$xmlFilePath = "$PathToExportXMLSiteColumns\$XMLTermsFileName"

 #Create Export Files
 New-Item $xmlFilePath -type file -force

 #Export Site Columns to XML file
 Add-Content $xmlFilePath "<?xml version=`"1.0`" encoding=`"utf-8`"?>"
 Add-Content $xmlFilePath "`n<Fields>"
 
 $SPOfields | ForEach-Object {
    if ($_.Group -eq $GroupToExport) {
        Add-Content $xmlFilePath $_.SchemaXml
    }
  }
 Add-Content $xmlFilePath "</Fields>"
