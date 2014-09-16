# Demonstration Application Build/Deploy Instructions

A demonstration application is included with this project so that new users who happen to come across this project can interact with its functionality prior to making an informed decision on whether or not it fits within their use case and requirements.

The demonstration application is hosted on Google App Engine (GAE). Therefore, the Google Cloud Platform tools must be installed and authenticated properly before these instructions can be followed. Please see [this](https://developers.google.com/cloud/sdk/?hl=es#Quick_Start) link for additional information.

**Updates to the live version of the demonstration application hosted on GAE is only possible by the project owners.**

## Instructions

* Build the Dart project with `pub` by running the following command in the repository root:

    ```
    pub build --mode=release
    ```

This `pub` command will compile and minify all assets and scripts associated with the project. A `build` folder will be created in the root of the repository which will hold the compiled project artifacts.

* Edit the `app.yaml` file to include the proper version designation in the `version:` key. Version designations must **not** contain a dot (.), therefore, dashes (-) are used as replacements. Versions must mimic their Git release tag counterparts (i.e. a Git release tag of 0.2.0 would become 0-2-0 in the `app.yaml` file).

* Change to the directory above the repository root directory by issuing the following command to the terminal:

    ```
    cd ..
    ```

* Upload the compiled project files to GAE by running the following command:

    ```
    appcfg.py update graph-paper
    ```

* After the `appcfg` script completes, verify that the application is working at this [link](http://graph-paper-demo.appspot.com/).