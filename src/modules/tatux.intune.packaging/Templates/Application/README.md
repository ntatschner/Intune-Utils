# Advanced Application Packaging with Intune

This project provides a framework for advanced application packaging with Microsoft Intune. It includes scripts and configuration files that automate the process of packaging applications for deployment through Intune.

The framework includes the following components:

- **Pre-Install Script (`Intune-Pre-Install.ps1`)** *OPTIONAL*: This script runs before the application installation. It can be used to perform tasks such as checking for prerequisites, closing running applications, or backing up user data.

- **Post-Install Script (`Intune-Post-Install.ps1`)** *OPTIONAL*: This script runs after the application installation. It can be used to perform tasks such as cleaning up temporary files, setting application preferences, or restoring user data.

- **Configuration File (`config.installer.json`)** **REQUIRED**: This JSON file contains configuration settings for the application installation, such as the install and uninstall switches, the uninstall path, and the target (user or system).

- **Main Installer Script (`Intune-I-MainInstaller.ps1`)** *DO NOT MODIFY*: This script is responsible for executing the installation process. It uses the configuration settings from the `config.installer.json` file to install the application.

- **Detection Script (`Intune-D-AppDetection.ps1`)** **REQUIRED**: This script is used by Intune to determine if the application is installed on a device. It checks for the presence of the application's version info file and compares its version to the required version.

This framework is designed to be flexible and can be customized to fit the needs of different applications. By using this framework, you can streamline your application packaging process and ensure consistent and reliable deployments with Intune.

### Outputs

The scripts and configuration file in this framework generate several outputs that can be used to monitor and troubleshoot the application packaging process:

- **Log Files**: The scripts generate log files that provide detailed information about each step of the installation and uninstallation process. These log files can be used to troubleshoot issues with the application packaging process. There is a function called **Write-RSYLog** (`Write-DeploymentLog.ps1`) being used throughout the framework, when editing the Pre-Install and Post-Install scripts make sure to use that for your logging.

- **Version Info File**: The `Intune-D-AppDetection.ps1` script checks for the presence of a version info file to determine if the application is installed. This file is typically created during the installation process and contains the version number of the installed application.

- **Exit Codes**: The scripts return exit codes that indicate the success or failure of the installation and uninstallation process. An exit code of 0 typically indicates success, while any other exit code indicates an error. The exact meaning of each exit code can vary depending on the application and installer.

- **Intune Deployment Status**: Once the application is packaged and deployed through Intune, you can monitor the deployment status in the Intune portal. This includes information about the number of devices that have received the application, the number of devices that have successfully installed the application, and any errors that occurred during the deployment process.

## Detailed Guide to Each File

### Configuration File (`config.installer.json`)

This JSON file contains configuration settings for the application installation. Here's a breakdown of its main components:

- **`name`**: The name of the application. This should match the name of the application as it will appear in Intune.

- **`filename`**: The name of the installer file for the application.

- **`installswitches`**: The command-line switches to be used when installing the application. These will vary depending on the installer being used.

- **`uninstallswitches`**: The command-line switches to be used when uninstalling the application. These will also vary depending on the installer.

- **`uninstallpath`**: The path to the uninstaller for the application. This is typically located in the application's installation directory. This is optional if the setup file can be used to uninstall the product too. 

- **`version`**: The version of the application. This should match the version number provided by the application's developer.

- **`precommandfile`**: The name of the script to be run before the application installation. This should match the name of the pre-install script file in the project.

- **`postcommandfile`**: The name of the script to be run after the application installation. This should match the name of the post-install script file in the project.

- **`target`**: The target of the installation. This can be either "user" or "system", depending on whether the application should be installed for the current user or for all users on the system. This determines where the logs files are generated based on contextual file system access. THIS NEEDS TO FOLLOW WHAT YOU CHOOSE IN INTUNE.

- **`shortcut`**: This field is used to create a desktop shortcut for the application. If left blank, no desktop shortcut is created. If populated, a desktop shortcut is created with the provided name. If you want to place the shortcut in a folder on the desktop, you can specify the folder and application name in the format `FOLDER\\AppName`. This will create a folder on the desktop (if it doesn't already exist) and place the shortcut inside it.

This field provides a flexible way to manage desktop shortcuts for your application. Be sure to test the shortcut creation process after modifying this field to ensure that it works as expected.

This file should be customized for each application that you're packaging with this framework. Be sure to test the installation and uninstallation process after modifying this file to ensure that everything works as expected.

### Pre-Install Script (`Intune-Pre-Install.ps1`)

This PowerShell script is executed before the application installation. It's designed to prepare the system for the installation of the application. Here's a breakdown of its main components:

- **Prerequisite Checks**: You can add code here to check for any prerequisites needed for the application to install correctly. This could include checking for required software, system specifications, or network connectivity.

- **Close Running Applications**: If the application to be installed is currently running, it may need to be closed before the installation can proceed. You can add code here to close any running instances of the application.

- **Backup User Data**: If the installation process could potentially affect user data, you can add code here to back up any necessary data before the installation begins.

The exact contents of this script will vary depending on the needs of the specific application being installed. It should be customized for each application that you're packaging with this framework. Be sure to test the script thoroughly to ensure that it correctly prepares the system for the application installation.

### Post-Install Script (`Intune-Post-Install.ps1`)

This PowerShell script is executed after the application installation. It's designed to finalize the installation and perform any necessary cleanup. Here's a breakdown of its main components:

- **Verify Installation**: You can add code here to verify that the application was installed correctly. This could include checking for the existence of certain files, querying the system for the installed application, or launching the application to ensure it starts correctly.

- **Set Application Preferences**: If the application has configurable settings or preferences, you can add code here to set those preferences according to your needs.

- **Cleanup Temporary Files**: If the installation process created temporary files, you can add code here to delete those files.

- **Restore User Data**: If you backed up user data in the pre-install script, you can add code here to restore that data.

The exact contents of this script will vary depending on the needs of the specific application being installed. It should be customized for each application that you're packaging with this framework. Be sure to test the script thoroughly to ensure that it correctly finalizes the installation and performs the necessary cleanup.

### Detection Script (`Intune-D-AppDetection.ps1`)

This PowerShell script is used by Microsoft Intune to determine if an application is installed on a device. Here's a breakdown of its main components:

- **Application Name and Version**: The script starts by defining the application name and version. These should match the name and version specified in your `config.installer.json` file.

- **Paths to Check**: The script then defines the paths where it will look for the version info file. This includes the Program Files directory and the AppData directory for each user.

- **Check Each Path**: The script checks each path in the `PathsToCheck` array. If the version info file is found and its version matches the required version, the script checks the target (user or system) and outputs a message indicating that the application is installed for the current user or all users. If the version info file is found but its version does not match the required version, the script outputs a message indicating that the version info does not match the required version.

- **No Version File Found**: If the script has not exited by the end of the `foreach` loop, this means that no version file was found. The script outputs a message indicating that the version file does not exist and exits with a status of 1.

This script should be customized for each application that you're packaging with this framework. Be sure to test the script thoroughly to ensure that it correctly detects the installation of the application.

### Packaging for Deployment to Intune

Once you have customized the configuration file and the pre-install and post-install scripts for your application, you are ready to package your application for deployment to Intune.

Here's a step-by-step guide on how to do this:

1. **Package the Application**: Use a packaging tool to package your application into an `.intunewin` file. The Microsoft Win32 Content Prep Tool can be used for this purpose. The command to create the package would look something like this:

    ```powershell
    .\IntuneWinAppUtil.exe -c source_folder -s setup_file -o output_folder
    ```

    Replace `source_folder` with the path to the folder containing your application files, `setup_file` with the name of your application's installer file, and `output_folder` with the path to the folder where you want to save the `.intunewin` file.

2. **Upload the Package to Intune**: In the Intune portal, create a new Win32 app. Upload your `.intunewin` file and provide the necessary information about the application.

3. **Specify Install and Uninstall Commands**: In the 'Program' step of the app creation process, specify the install and uninstall commands for your application. The install command should be `"%windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File Intune-I-MainInstaller.ps1"`, and the uninstall command should be `"%windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File Intune-I-MainInstaller.ps1 -Uninstall"`.

4. **Configure Detection Rules**: In the 'Detection rules' step, configure the rules that Intune will use to determine whether the application is already installed on a device. You can use the provided detection script (`Intune-D-AppDetection.ps1`) to accurately determine the installation state of the application. This script checks for the presence of the application's config file, then compares its name and version to the required version. In the Intune portal, you can specify this script as a custom detection rule.

5. **Assign the Application**: In the 'Assignments' step, choose the groups that should receive the application.

6. **Review and Create**: Review your settings and then create the app.
