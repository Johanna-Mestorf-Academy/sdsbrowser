# For developers

The sdsbrowser app was developed as an [R package](http://r-pkgs.had.co.nz/intro.html) that provides only one function to start a [R Shiny Webapp](https://shiny.rstudio.com): `sdsbrowser::sdsbrowser()`. sdsbrowser depends on the availability of SDS data from the Johanna Mestorf Academy [Data Exchange Platform](https://www.jma.uni-kiel.de/en/research-projects/data-exchange-platform/sds-2013-systematic-digital-collection-of-data-sets-of-stone-artefacts) and on the implementation of loading and decoding algorithms for data and metadata in an additional R package [sdsanalysis](https://github.com/Johanna-Mestorf-Academy/sdsanalysis). The app is hosted within a Docker container (see below) on a server at the [Institute of Pre- and Protohistoric Archaeology](https://www.ufg.uni-kiel.de) of Kiel University.

## sdsbrowser, sdsanalysis and the JMA Data Exchange Platform

sdsbrowser does not store data, it downloads it on demand from other sources. This setting was chosen to avoid breaching any license or copyright conditions by uploading it to github. The referencing of dataset name and location/url happens within the sdsanalysis package, more specifically in a dedicated metadata storage file [dataset_metadata_list.csv](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/dataset_metadata_list.csv). The table contains some minimum information for each dataset, like it's author, the relevant site, dating, coordinates and most importantly where the correctly prepared files can be downloaded. At the moment most datasets are provided by the above mentioned JMA Data Exchange Platform.

sdsanalysis offers some helper functions to query the metadata table. This is used in sdsbrowser to provide the overview and selection in the *Load Data* tab. It also offers functions to download the registered SDS datasets directly into R, which might be useful not just for sdsbrowser, but also for archaeologists who actively want to work with the available data. It's main purpose though is to decode the cryptic coding system of SDS to a human readable form. You will find more information on that in the documentation of sdsanalysis. sdsanalysis requires a special formatting layout to be able to deal with input SDS tables. More on this in the section [A new dataset](#a-new-dataset).

## sdsbrowser: Internal file structure

sdsbrowser is an R package. That defines a file structure and a general development cycle -- too complex to explain here. If you are interested, please start to read [this](](http://r-pkgs.had.co.nz/intro.html)) introduction. Instead I wanted to explain some details of the implementation to make it more easy later to find the relevant files to apply changes. 

```
| Dockerfile
```

See section [Docker and deployment](#docker-and-deployment).

```
| inst
  | sds_logo
    | colour
    | negativ
    | favicon
```

The `inst/` directory of an R package can contain additional data and material not directly related to the package's purpose. Here it also contains the rendered and raw data for the SDS logo. This logo was designed by [Janine Cordts](http://www.ufg.uni-kiel.de/en/staff-directory/non-scientific-collaborators/janine-cordts-1) explicitly for the SDS stone artefact documentation system and can not be used for any other purposes. 

```
| inst
  | style
    | sdsbrowser_stylesheet.css
```

A rather complex shiny app like sdsbrowser usually requires some tweaks and custom stylesheet definitions. `sdsbrowser_stylesheet.css` contains important stylesheet information for the interactive webpage. This file is loaded into the page header [here](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/4bd4d54c39de1b39d5d93a63c4b713feaa8c0856/R/app_sdsbrowser.R#L112). 

```
| R
  | app_browser.R
  -
  | ui_load_data_view.R
  | server_load_data_view.R
  -
  | ui_table_view.R
  | server_table_view.R
  -
  | ui_plot_view.R
  | server_plot_view.R
    | server_plot_view_multi.R
    | server_plot_view_single.R
  -
  | server_exploration_view.R
  | ui_exploration_view.R
  -
  | helpers_data_interaction.R
  | helpers_plot.R
```

As stated above the sdsbrowser package only provides one external function: `sdsbrowser::sdsbrowser()`. This function is defined in `app_browser.R` and binds the final app together from a `ui` and a `server` function -- [as usual for shiny apps](https://shiny.rstudio.com/articles/basics.html). The `ui` method constructs the user interface as a `shinydashboard::dashboardPage()` from a sidebar and a body section. While the sidebar is stable and defined only once, the body contains various content elements that change in appearance depending on data and user input. These content elements require a lot of additional code for each tab (*Load Data View*, *Table View*, *Plot View*, *Exploration View*) while the tabs are mostly independent -- except for sharing the selected dataset. A setup like this can be handled with [shiny modules](https://shiny.rstudio.com/articles/modules.html), where each tab is implemented as an independent set of `ui` and `server` functions. Therefore the lines following [this one](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/4bd4d54c39de1b39d5d93a63c4b713feaa8c0856/R/app_sdsbrowser.R#L146) only contain calls to dedicated `ui` functions and the lines following [this one](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/4bd4d54c39de1b39d5d93a63c4b713feaa8c0856/R/app_sdsbrowser.R#L185) in the main `server` function only calls to the respective module functions. That explains the hierarchy and interaction of the functions defined in the `R/` directory.

The special cases: 

1. The *Introduction View* is not as complex and mostly consist of a [embedded version](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/4bd4d54c39de1b39d5d93a63c4b713feaa8c0856/R/app_sdsbrowser.R#L136) of the sdsbrowser README.md file. 

2. The *Load Data* module downloads and prepares data for all the other tabs. Therefore it returns a [reactive object](https://shiny.rstudio.com/articles/reactivity-overview.html) and [hands it to the other tabs](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/4bd4d54c39de1b39d5d93a63c4b713feaa8c0856/R/app_sdsbrowser.R#L185). 

3. The *Plot View* contains two basically different content compilations for single and multi SDS data (Einzelaufnahme vs. Sammelaufnahme) with a switch to decide which one to show. The plots are also pretty complex individually and are therefore outourced to a set of `server` module functions in `server_plot_view_multi.R` and `server_plot_view_single.R`. 

## Docker and deployment

The sdsbrowser web app can be run in a [docker](https://opensource.com/resources/what-docker) container. The relevant Dockerfile is stored [here](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/master/Dockerfile). 

If you have docker installed and running on your system you can build the container with the following command:

```
docker build -t sds:1.0 .
```

You can then start the container with:

```
docker run --name sdsbrowser -d -it -p 3838:3838 --restart=always sds:1.0
```

The app is then available on `127.0.0.1:3838` in your browser.

If you already have the container running and want to upgrade to a newer version, than you have to stop (`docker stop sdsbrowser`) and remove (`docker rm sdsbrowser`) it and start it again from the new image.

## Update tasks 

The main maintenance tasks for sdsbrowser should be to add new data. The app by itself should be fairly stable within the docker container. The following sections contain step-by-step instructions on how to prepare and upload new SDS datasets for sdsbrowser and sdsanalysis. These instructions are written specifically for the main deployment scenario of sdsbrowser at the Institute of Pre- and Protohistoric Archaeology in Kiel. 

### A new dataset

1. Make sure that you can share the data online and that there's a clear data license definition available. 

2. Change the data structure. The following rules apply (read carefully and compare with the available datasets!):
  - SDS datasets must be comma separated .csv files with a single header row.
  - The file must have UTF-8 encoding. 
  - Character values must be in double quotes.
  - The decimal separator must be ".".
  - Each column must represent one variable, variables are not to be combined from single digit columns as originally suggested for SDS.
  - Each column/variable must have a unique name as defined in the column "variable_id" in this [variable_list.csv](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/variable_list.csv) metadata table. If your data has other variable names (only numbers, long german names, etc.) they have to be changed. If you have a column/variable that is not present in this reference list, than you can leave the name as it is -- it will be ignored -- or add [A new sds variable](#a-new-sds-variable).
  - SDS datasets can be for *single* artefact data (Einzelaufnahme) or for *multi* artefact data (Sammelaufnahme). Depending on this distinction, the meaning of individual rows/objects change. In a single artefact dataset, one row equals one artefact. In multi artefact datasets it **can** (but doesn't have to) mean a group/collection of artefacts. The single artefact data concerns the *Formblätter* 1-5, the multi artefact data *Formblatt* 7. *Formblatt* 6 is for artefact fragment fitting (Zusammenpassungen) and not implemented in sdsbrowser. If your dataset consists of multiple files separated by *Formblatt*, than you have to merge them. Some example code on how to do this can be found [here](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/playground/merge_data.R). It **might** also be useful to extract single artefact data from multi artefact collections. [Here](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/playground/unmulti_single_data_brozio.R)'s some example code for the transformation of group variables to single variables.

3. Write a short description file for the dataset. 5-7 sentences maximum. The file must be a simple .txt file with UTF-8 encoding.

4. Upload the files (SiteX_description.txt, SiteX_single.csv, SiteX_multi.csv) to the JMA Data Exchange Platform or another archive with direct, raw file access.

5. Add the new dataset according to the other, already added datasets to the [dataset_metadata_list.csv](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/dataset_metadata_list.csv) file in sdsanalysis and commit and push the changes to the master branch on github. 

This should be sufficient. The new dataset should now be accessible via sdsbrowser. If the new dataset is not immediately visible, that might be a caching issue: sdsbrowser (through sdsanalysis) stores a version of the metadata list locally for 10 minutes or until the server is restarted. You can check the result independently with the following sdsanalysis functions: 

```
description <- sdsanalysis::get_description("id of your dataset")
single <- sdsanalysis::get_single_artefact_data("id of your dataset")
multi <- sdsanalysis::get_multi_artefact_data("id of your dataset")

sdsanalysis::lookup_everything(single)    
sdsanalysis::lookup_everything(multi)  
```

It's possible that new datasets add new variables or new values/categories within this datasets. In this case please take a look at the following two sections.

### A new sds variable

1. Add the new variable according to the already available ones to the [variable_list.csv](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/variable_list.csv) file in sdsanalysis.

2. Run the [data_prep.R](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/data_prep.R) script within the sdsanalysis package. 

3. Commit and push the changes to the master branch on github. If you also have values/categories for this new variable that should be decoded, than please go to [A new possible value for a SDS variable](a-new-possible-value-for-a-sds-variable).

4. Trigger a rebuild of the sdsbrowser image on [dockerhub](https://hub.docker.com/r/johannamestorfacademy/sdsbrowser/). This takes about an hour. 

5. When the container is built, than upgrade the container on the server as described in [Docker and deployment](#docker-and-deployment).

### A new possible value for a SDS variable

1. Add the new variable according to the already available ones to the [variable_values_list.csv](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/variable_values_list.csv) file in sdsanalysis. Please consider the long data format: Each value of each variable is represented by an individual row.

2. Run the [data_prep.R](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/data_prep.R) script within the sdsanalysis package. 

3. Commit and push the changes to the master branch on github.

4. Trigger a rebuild of the sdsbrowser image on [dockerhub](https://hub.docker.com/r/johannamestorfacademy/sdsbrowser/). This takes about an hour. 

5. When the container is built, than upgrade the container on the server as described in [Docker and deployment](#docker-and-deployment).
