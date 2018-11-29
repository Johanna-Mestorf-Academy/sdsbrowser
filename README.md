[![Travis-CI Build
Status](https://travis-ci.org/Johanna-Mestorf-Academy/sdsbrowser.svg?branch=master)](https://travis-ci.org/Johanna-Mestorf-Academy/sdsbrowser)
[![Docker Build Status](https://img.shields.io/docker/build/johannamestorfacademy/sdsbrowser.svg)](https://hub.docker.com/r/johannamestorfacademy/sdsbrowser)
[![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/master/LICENSE)

# sdsbrowser

#### **What is SDS?**

SDS (*Systematic and Digital Documentation of Stone Artefacts*) [1] is a recording system for stone artefacts. It was created as an uniform coding and standardized listing system of conventional attributes recorded at lithic inventories to enable well structured, quantitative, and comparative analysis. The variable collection in SDS was compiled from several established documentation systems [2]-[7].

<img align="right" style="padding-left:20px; padding-bottom:10px;" src="https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsbrowser/master/inst/sds_logo/colour/Logo_SDS_colour_300dpi.png" width = 270>

As of November 2018, the SDS system is only available in a german language version.

#### **What is the sdsbrowser and how can I use it?**

sdsbrowser is an R Shiny WebApp developed to make the available SDS datasets more accessible. It is designed to give you a quick overview on the spatial and temporal scope of sites previously analysed with SDS and the distribution of artefacts within these sites. This might be especially interesting if you are in search for comparison datasets for your own stone tool collection. Since sdsbrowser allows you to download the registered datasets in a standardized and human-readable format, data preparation and meaningful statistical analysis should be a lot simpler and straightforward.

#### **Where is the data coming from and what do I have to do if I want to use the data for my research?**

Most of the data was collected in various research projects at Kiel University, mostly within the [SPP 1400: Early Monumentality and Social Differentiation](http://gepris.dfg.de/gepris/projekt/73281462?language=en). sdsbrowser does not store any information, but queries it dynamically from the [Research Data Exchange Platform](https://www.jma.uni-kiel.de/en/research-projects/data-exchange-platform) of the [Johanna Mestorf Academy](http://www.jma.uni-kiel.de/en). There is a special page where all the SDS datasets are combined: [here]().

If you want to use one of the data collections for your research, you must abide by the terms of the the individual dataset's license. If no license is defined on the special download page, you will have to contact the dataset authors and ask for permission. The code in [sdsbrowser](https://github.com/Johanna-Mestorf-Academy/sdsbrowser) and [sdsanalysis](https://github.com/Johanna-Mestorf-Academy/sdsanalysis) is published under the [GNU General Public License, version 2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).

#### **What can the sdsanalysis R package do for me?**

If you are familiar with the scientific scripting language [R](https://www.r-project.org/), than the sdsanalysis package might be useful for your work with SDS data. It provides functions to download the available datasets (the ones also accessible in sdsbrowser) and to quickly transform the numerically coded information in SDS to a human readable format. You can find more information and some code examples on the projects [github page](https://github.com/Johanna-Mestorf-Academy/sdsanalysis).

#### **Who can I contact if I want to know more about the SDS system or this Webapp?**

If you want to know more about SDS, you may want to start by taking a look at the main article about the system from 2008 by Anselm Drafehn, [Marcel Bradtmöller](https://www.altertum.uni-rostock.de/institut/mitarbeitende/marcel-bradtmoeller) and [Doris Mischka](http://www.uf.uni-erlangen.de/prof-doris-mischka/) [1]. Over the years it was slightly modified and enlarged. Therefore it might be useful to talk with some people who recently worked with it, e.g. [Jan Piet Brozio](https://www.ufg.uni-kiel.de/en/staff-directory/scientific-collaborators/jan-piet-brozio) or [Gesa-Kristin Salefsky](https://de.linkedin.com/in/gesa-salefsky-37a651157). One particularly important but unpublished addition was a formsheet for the documentation of artefact groups (*Sammelaufnahme*). You can find some information about this from 2009  [here](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/raw/master/data-raw/SDS_Formblatt_7.pdf). 

The sdsbrowser Webapp was initially developed by [Clemens Schmid](https://nevrome.de/) in 2018. The source code is available [here](https://github.com/Johanna-Mestorf-Academy/sdsbrowser). It is maintained by [Christoph Rinne](https://www.ufg.uni-kiel.de/en/staff-directory/scientific-collaborators/christoph-rinne). 

<hr class="nicehr">

#### References

<sup>[1] A. Drafehn/M. Bradtmöller/D. Mischka, SDS – Systematische und digitale Erfassung von Steinartefakten (Arbeitsstand SDS 8.05). Journal Of Neolithic Archaeology 10, 2008. doi:10.12766/jna.2008.25</sup>  
<sup>[2] A. Zimmermann, Die bandkeramischen Pfeilspitzen aus den Grabungen im Merzbachtal. In: R. Kuper/H. Löhr/J. Lüning/P. Stehli/A. Zimmermann, Der bandkeramische Fundplatz Langweiler 9, Gemeinde Aldenhoven, Kreis Düren. Beitr. Zur neolithischen Besiedlung der Aldenhovener Platte II. Rhein. Ausgr. 18 (Köln 1977) 351-417.</sup>  
<sup>[3] S. Hartz, Die Steinartefakte des endmesolithischen Fundplatzes Grube-Rosenhof. Studien an Flintinventaren zur Zeit der Neolithisierung in Schleswig-Holstein und Südskandinavien. Untersuchungen und Materialien zur Steinzeit in Schleswig-Holstein 2 (Neumünster 1999).</sup>  
<sup>[4] H. Lübke, Die steinzeitlichen Fundplätze Bebensee LA 26 und LA 76, Kreis Segeberg. Die Steinartefakte Technologisch-ergologische Studien zum Nordischen Frühneolithikum. Untersuchungen und Materialien zur Steinzeit in Schleswig-Holstein 3 (Neumünster 2000).</sup>  
<sup>[5] B. Auffermann/W. Burkert/J. Hahn/C. Pasda/U. Simon, Ein Merkmalsystem zur Auswertung von Steinartefaktinventaren. Archäologisches Korrespondenzblatt 20, 1990, 259–268.</sup>  
<sup>[6] A. Drafehn, Der mesolithische Fundplatz Teveren 115 A. Unveröffentliche Magisterarbeit (Köln 2004).</sup>  
<sup>[7] B. Gehlen, A Microlith Sequence from Friesack 4, Brandenburg, and the Mesolithic in Germany. In: P. Crombé, M. Van Strydonck, J. Sergant, M. Boudin & M. Bats (eds.), Chronology and evolution within the Mesolithic of North-West Europe: proceedings of an international meeting, Brussels, May 30th-June 1st 2007 (Cambridge 2009) 363-393.</sup>  

<hr class="nicehr">

#### For developers

The sdsbrowser app was developed as an [R package](http://r-pkgs.had.co.nz/intro.html) that provides only one function to start a [R Shiny Webapp](https://shiny.rstudio.com): `sdsbrowser::sdsbrowser()`. sdsbrowser depends on the availability of SDS data from the Johanna Mestorf Academy [Data Exchange Platform](https://www.jma.uni-kiel.de/en/research-projects/data-exchange-platform/sds-2013-systematic-digital-collection-of-data-sets-of-stone-artefacts) and on the implementation of loading and decoding algorithms for data and metadata in an additional R package [sdsanalysis](https://github.com/Johanna-Mestorf-Academy/sdsanalysis). The app is hosted within a Docker container (see below) on a server at the [Institute of Pre- and Protohistoric Archaeology](https://www.ufg.uni-kiel.de) of Kiel University.

##### sdsbrowser, sdsanalysis and the JMA Data Exchange Platform

##### sdsbrowser: Internal file structure

sdsbrowser is an R package. That defines a file structure and a general development cycle -- too complex to explain here. If you are interested, please start to read [this](](http://r-pkgs.had.co.nz/intro.html)) introduction. Instead I wanted to explain some details of the implementation to make it more easy later to find the relevant files to apply changes. 

```
| .travis.yml
```

To continuously test and ensure the package's functionality and integrity we run checks for every push to the master branch on [Travis CI](https://travis-ci.org/Johanna-Mestorf-Academy/sdsbrowser). The `.travis.yml` file contains the necessary configuration for this. It can be adapted according to the documentation [here](https://docs.travis-ci.com/user/languages/r/). The encrypted secret passed to travis is an environment variable `GITHUB_PAT` that contains a [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) for github. This is necessary, because this package depends on remote packages from github (see the `DESCRIPTION` file). Travis has to download them for each build (via `devtools::install_github()`) and thereby rapidly exceeds the github API limits. To extend this limits we need a personal token which has to be passed to travis in an [encrypted form](https://docs.travis-ci.com/user/environment-variables/#encrypting-environment-variables) to prevent a serious security breach.

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

##### Docker and deployment

sdsbrowser is available prepackaged in a [docker](https://opensource.com/resources/what-docker) image on [dockerhub](https://hub.docker.com/r/johannamestorfacademy/sdsbrowser). The relevant Dockerfile is stored [here](https://github.com/Johanna-Mestorf-Academy/sdsbrowser/blob/master/Dockerfile). The image is built every time somebody pushes to the master branch of the sdsbrowser repository on github to make sure that it always reflects the latest development version. This continous integration setup is nice but it also makes it more important to only push a working package version to the master branch. 

If you have docker installed and running on your system you can start the app directly by running the following line of code on your shell. This will download the latest constructed image from dockerhub and start the app within the container -- or more precisely a shiny server that provides the app. For the configuration of this shiny server please see the Dockerfile. 

```
docker run --name sdsbrowser -d -it -p 3838:3838 --restart=always johannamestorfacademy/sdsbrowser
```

You can access the app on `127.0.0.1:3838` in your browser.

If you already have it running and want to upgrade to a newer version, than you have to stop, delete and eventually replace the running container:

```
docker stop sdsbrowser && docker rm -v $_ && docker pull johannamestorfacademy/sdsbrowser && docker run --name sdsbrowser -d -it -p 3838:3838 --restart=always johannamestorfacademy/sdsbrowser
```

If you want to build the image by yourself, you only need the Dockerfile and some patience:

```
docker build -t sds:1.0 .
```

##### Update tasks 

###### A new dataset

###### A new sds variable

###### A new possible value for a SDS variable
