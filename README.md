# berglie/assembly-version
This repository contains two actions; *set-buildnumber* for setting the assembly build number and *get* for getting the assembly version from a specified file. 

## berglie/assembly-version/set-buildnumber
This action will help replace the build number in the assembly info file (which is included in most .Net projects) with [github.run_number](https://docs.github.com/en/actions/learn-github-actions/contexts) or a custom number. 

Use this action before a build job to include the build number in the assembly version.

Note: It will also work for any other files that can be opened as a text file and contains the version in the format: <code>major.minor.patch.build</code>

The version is returned from the action output in format <code>major.minor.patch.build</code>. 

For example: *1.0.0.0*.

Use <code>${{steps.*step-id-here*.outputs.version}}</code> to get the version number in a GitHub workflow. Remember to set the id on the step.

### Example Usage
Automatically replace all *AssemblyInfo.cs* files with buildnumber [github.run_number](https://docs.github.com/en/actions/learn-github-actions/contexts)
```yml
- name: Set build number
  uses: berglie/assembly-version/set-buildnumber@v1
```

#### Optional Parameters
```yml
- name: Set build number
  id: setversion
  uses: berglie/assembly-version/set-buildnumber@v1
      with:
        filename: 'SharedAssemblyInfo.cs'
        directory: './src/'
        buildnumber: ${{ env.RELEASE_VERSION }}		
        recursive: false
```

## berglie/assembly-version/get
This action will help get the file version from the properties of a specified file. If the version of the file is not found, it will try to read the file as a text file and locate the version as a string, such as in 'AssemblyInfo.cs'

The version is returned from the action output in format <code>major.minor.patch.build</code>. 

For example: *1.0.0.0*.

Use <code>${{steps.*step-id-here*.outputs.version}}</code> to get the version number in a GitHub workflow. Remember to set the id on the step.

### Example Usage
```yml
    - name: Get Assembly Version
      uses: berglie/assembly-version/get@v1
      with:
        filename: 'MyLibrary.dll' 
```

#### Optional Parameters
```yml
    - name: Get Assembly Version
      id: getversion
      uses: berglie/assembly-version/get@v1
      with:
        filename: 'MyExecutable.exe'
        directory: './src/'        
```