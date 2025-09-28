# Project Tech Discussion - Meeting Minutes

## Key Points

* **Core Conflict:** The client has requested a "script," but Frank believes a complete application with a user interface is necessary based on the functional requirements (file uploads, data visualization).
    * This is the biggest cognitive gap at present.
* **Technical Path:** The back-end technology stack is confirmed to be SQL (for data processing) and R (for data analysis and visualization).
    * If a front-end is required, options include R Shiny, React, or pure HTML/CSS/JS.
* **Data Flow:** The team is not responsible for sourcing data.
    * The core task is to enable the uploading of client-provided CSV files, database import, analysis, chart generation, and exporting results.
* **Priority Action:** It is imperative to schedule a clarification meeting with the client immediately to resolve fundamental questions about the final deliverable and user interaction model.
    * The project cannot move forward otherwise.

## Main Discussion and Conclusions

### 1. Tech Stack Discussion

**If a Front-End is Needed: Web Application Frameworks**
* Frank suggested considering R's Shiny app, as it is easy to deploy and allows for convenient remote access by users.
* The team also discussed the possibility of combining other languages and frameworks, such as using Python's Flask or Django for the back-end, or React for the front-end.
* To simplify front-end development, plain HTML, CSS, and JavaScript could also be used.

### 2. Core Conflict: Just a "Script" or a Full Application?

* **Client's Requirement:** The client explicitly stated they only need the team to write a "script" that solely involves a database language (like SQL) and the R language.
* **Team's Understanding:**
    * Frank believes the so-called "script" is actually functional code embedded in the back-end.
    * This script would handle data processing (SQL part) and analysis/visualization (R part), forming the system's back-end.
    * A front-end user interface (UI) is essential for non-technical staff to use the system.
    * Otherwise, users would have to interact with the script via the command line, which is not user-friendly.

### 3. API and Data Interaction

* **API Issue:** Frank proposed that if no front-end is developed, an API should be provided so the client's existing applications can call our service.
    * However, the client stated that an API is not necessary as they do not currently have one.
* **Data Flow:**
    * The team clarified that the project does not include sourcing data from the original website (e.g., TCSI).
    * The client will provide data files (as CSVs), and our system must allow them to upload these files into the database.
    * The R script part of the system will be responsible for analyzing the data in the database, generating charts and tables, and enabling export to CSV files.

### 4. Current Bottleneck

* The team unanimously agreed that the biggest bottleneck for the project is the misunderstanding of the client's requirements, especially regarding the need for a front-end user interface.
* The project cannot proceed smoothly until this issue is resolved.

## Conclusion and Action Plan

* **Conclusion:** We must communicate with the client immediately to clarify the final form of the project.
    * There is currently a significant discrepancy between the team's understanding and the client's description of a "script."
* **Next Steps:**
    * **Schedule an Urgent Meeting:** Email the client as soon as possible to request a clarification meeting.
    * **Prepare a List of Clarifying Questions:** Before meeting with the client, we need to prepare a list of questions to ensure a comprehensive understanding of their needs.
    * **Key questions include:**
        * **User Interaction Method:** Ask the client to describe specifically how they expect their employees to use our deliverable. Will it be through a website, a desktop application, or some other method?
        * **Definition of "Script":** Ask the client to explain in more detail what they mean by a "script" and what its operating environment will be.
        * **Confirmation of Front-End UI:** Considering the need for file uploads and data visualization, should we provide a graphical user interface?
        * **Integration and API:** If they do not want a front-end from us, do they have an existing application system? Do we need to provide an API to connect our back-end service to their existing systems?
