# H&M Code Example
Simon Wu 

Email: simon.wu@afry.com

Phone: 0764785168

Github repo with code: https://github.com/Simon-s-example-Script-for-H-M/Example-Script

## AFRYX-Data-Analytics-Platform-Snippet (Terraform and Python)
### Motivation: 
In this script, I want to show an Infrastructure as Code example which I have written. It is a subset from our AFRYX-Data-Analytics-Platform (AXD) infrastructure, but modified to make work independently. 

I choose this code as a demonstration of way of thinking behind infrastructure as code, which involves both terraform and python.

### Background and Problem description:
In AXD, we want to provide data ingestion functionality using data factory, which performs ETL activities between blob storage (raw data storage) and data lake (processed data storage). 

Azure Data factory pipelines consist of link services (authorization to storage accounts), datasets (targeting a specific file format and file path inside a storage account), triggers (time or event based triggers) and activities (ETL activities). These above mentioned building blocks are all stored as JSON files inside data factory studio, and data factory pipelines are high level JSON file that calls on these building blocks. A data factory pipeline thereby performs a series of ETL activities that connects a source and a sink dataset inside 2 storage account (authorized by link services), and runs based on a defined trigger.  

![text](https://github.com/Simon-s-example-Script-for-H-M/Example-Script/blob/main/datafactory_illustration.png)

When setting up a data factory environment, a common solution is to connect data factory to an external git repo, which contains the essential JSON scripts for the pipelines of interest. Data factory will then be able to construct these pipelines based on the provided JSON scripts. 

### Challenges:
Pipelines configuration (especially the included datasets) depends from use-case to use-case, and having one ready high level JSON scripts for each pipeline configuration inside a repo is not scalable. 

### Solution:
A cloud native modularized solution is to have a repo with all essential building blocks (link services, datasets, triggers and activities), and construct the high level pipeline JSON file based on the users need when an infrastructure is being set up.

### Script description:
This script is an infrastructure as code script based on terraform and python. It contains terraform scripts for blob storage, data lake and data factory resources, as well as template JSON files for data factory link services, datasets and triggers. 

What happens in the background when the script is being executed can be summarized as:

•	(**The instructions for how to run the code can be found in the README.md inside the folder**)

•	(**Due to lack of time, some dependencies between resources are not properly established, but this can be solved by running “terraform apply” several times when encountering errors.**)

•	Terraform deploys a blob storage & container, a datalake & datalake-file-system, a data factory resource and a github repo.

•	Based on the dynamical parameters from the deployed resources mentioned above, python codes are executed inside terraform, which inserts the parameters to the template JSON files for link services, datasets and triggers.

•	Based on a user-defined pipeline configuration given in “terraform.tfvars”, a python code is executed to generate a high level pipeline JSON file which is customized based on the users wish.

•	All data factory related JSON files are uploaded to the github repo

•	The github repo is connected to data factory to set up the data factory environment

•	Based on the user-defined source file URL, the corresponding source file is uploaded to blob storage, which in order triggers the data factory pipeline to run.


## Crack-Detection-MVP (Python)
### Motivation
In this code, I want to show the MVP for an internal project about crack detection on google street view images. This project includes machine learning (object detection) as well as software development. Since this was an MVP, the focus of the code was placed on functionality, rather than performance or strict coding standard.

Also, to make the code easily runnable, I excluded the machine learning related scripts from the folder, and only included scripts that builds the navigation platform, provided with images obtained from the trained and tunned detectron-2 model.

### Background and Problem description:
The project aimed to develop a MVP for a 360 panoramic platform, where the user can navigate inside a webservice similar to google street-view, but view detected cracks and potholes on roads inside the street-view. The project contained 2 tracks. The first one was to tune and train an open source image detection model (detectron2 from facebook) based on custom processed cracks and potholes images, The second one was to develop a 360 panoramic platform (inspired by google street-view) in which the user can navigate in (go back and forth, zoom in and out and change view angle), based on stitched 360 images requested from google street-view API. These two tracks was then combined to accomplish a MVP for the platform, where the user can enter start and destination coordinates, and then navigate on the corresponding route inside a panoramic space based on google street-view images, with the detected crack and potholes on the road visualized.

### Challenges:
To reconstruct a navigation platform similar to google street view, the street view image tiles requested from google developer API needs to be stitched to a panoramic space. Also, the platform needs to provide navigation functionalities for the user to look around, zoom in and out at a positions, as well as moving back and forth between positions.   

### Solution:
We used OpenGL for image stitching and Pygame for the platfrom

### Script description:
•	The instructions for how to run the code can be found in the README.md inside the folder

•	OpenGL will create a 3D model (3D cubic space) based on 6 image tiles with different heading angles per time, and load it inside a Pygame screen.

•	The Pygame screen is programmed to react to mouse actions, and the user are able to change viewing angle, zoom in and out inside a cubic space, or move back and forth between cubic spaces on a defined route.
