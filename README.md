# Pline plugins repository

This repository collects interface plugins and pipelines for the [Pline interface generator](https://github.com/veidenberg/pline).
A plugin is a folder containing the interface description - a `plugin.json` file, and (optionally) compiled files for the targeted command-line program.
Pipelines are  `pipeline_name.json` files that store a chain of plugins with prefilled inputs and may be accompanied with example input files. You can find pipelines from the `pipelines` folder.
You can read more about Pline and see the plugin interfaces in action on the [Pline website](http://wasabiapp.org/pline).

## Installation

1) [Download Pline](https://github.com/veidenberg/pline)
2) Download some plugins or pipelines from this repo
3) Drop the plugins/pipelines to the dedicated direcotry (by default `path/to/Pline/plugins/` and `.../plugins/pipelines`).
Or
1) Download a Pline+plugin package from the [downloads site](http://wasabiapp.org/pline/downloads).

## Usage

1) Launch Pline server: `python path/to/Pline/pline_server.py`
2) Open a web browser an go to http://localhost:8000
3) Select an interface or pipeline from the **Tools** or **Pipelines** menu
4) Fill the inputs and click **RUN** to launch the command-line tool/pipeline
5) Collect the result files from the data folder (by default `path/to/Pline/analyses/`)

## Contributing

Although the [plugin API](http://wasabiapp.org/pline/guide) tries to make interface crafting easy, the best plugins are the ones you don't have to write yourself.
If you have written a Pline interface plugin that could be useful to others, you are welcome to add it to this repository by submitting a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests).
