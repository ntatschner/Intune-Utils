# Validates the Intune logo image file complies with the requirements of a PNG or JPG with a max resolution of 256x256 pixels.
function Test-IntuneLogoImage {
    <#
.SYNOPSIS
Tests if an Intune logo image file complies with the requirements of a PNG or JPG with a max resolution of 256x256 pixels.

.DESCRIPTION
The Test-IntuneLogoImage function validates an image file based on the following criteria:
- The file exists
- The file is a PNG or JPG
- The image resolution is less than or equal to 256x256 pixels

.PARAMETER Path
The path of the image file to validate.

.EXAMPLE
Test-IntuneLogoImage -Path "C:\path\to\image.png"

This command tests if the image at the specified path is a valid Intune logo image.

.OUTPUTS
Boolean. Returns $true if the image is a valid Intune logo image, and $false otherwise.

.NOTES
Additional information about the function.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    begin {
        $FileName = Split-Path -Path $Path -Leaf
    }
    process {
        # Validate the file exists
        if (-not (Test-Path -Path $Path)) {
            Write-Error "The image '$FileName' does not exist."
            return $false
        }
        # Validate the file is a PNG or JPG
        $extension = [System.IO.Path]::GetExtension($Path)
        if ($extension -ne ".png" -and $extension -ne ".jpg") {
            Write-Error "The The image '$FileName' is not a PNG or JPG."
            return $false
        }
        # Validate the file is less than 256x256 pixels
        $image = [System.Drawing.Image]::FromFile($Path)
        if ($image.Width -gt 256 -or $image.Height -gt 256) {
            Write-Error "The image '$FileName' is larger than 256x256 pixels."
            $image.Dispose()
            return $false
        }
        # Dispose of the image
        $image.Dispose()
        return $true
    }
}