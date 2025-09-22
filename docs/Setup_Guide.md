## 📄 .Renviron File: Purpose and Setup

.Renviron is a hidden file that stores environment variables for R. It is loaded automatically when R starts.

### 1. Objective of the usage:

- Keeps sensitive information like database passwords out of scripts.
- Makes scripts portable and safe to share.
- Works for any OS (Windows, Mac, Linux).

### 2. Recommended Variables for Database Connection

For this project, create the following variables:
```bash
DB_HOST=localhost			# Database server IP or hostname
DB_PORT=5432			    # default PostgreSQL port
DB_NAME=TCSI_Extract_DB 	# Database name
DB_USER=postgres			# Username
DB_PASSWORD=<your_password_here>	# Database password
```
- Replace <your_password_here> with your actual database password.
- Use the same variable names exactly, as your R script references them with `Sys.getenv()`.

### 3. File Location by Operating System

| OS      | File Path / Location                      | Notes                                                                          |
| ------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| Windows | `C:/Users/<username>/Documents/.Renviron` | Hidden file. If it doesn’t exist, create it manually using Notepad.            |
| Mac     | `/Users/<username>/.Renviron`             | Hidden file in home directory. Use Finder → Go → Go to Folder → `~` to see it. |
| Linux   | `/home/<username>/.Renviron`              | Hidden file in home directory. Can create via terminal: `nano ~/.Renviron`     |


💡 Tip: Use a plain text editor (Notepad, TextEdit, VS Code) to create/edit .Renviron

### 4. Steps to Create .Renviron

**Windows**

1. Open Notepad.
2. Paste the environment variables with correct values:

```bash
DB_HOST=localhost
DB_PORT=5432
DB_NAME=TCSI_Extract_DB
DB_USER=postgres
DB_PASSWORD=your_password_here
```
3. Save the file as .Renviron in C:/Users/<username>/Documents/.
    - Make sure the file name has no extension (not .txt).
    - Set "Save as type" to "All Files (.)" in Notepad.

**Mac / Linux**

1. Open Terminal.
2. Navigate to your home directory:
```bash
cd ~
```
3. Open or create .Renviron:
```bash
nano .Renviron
```
4. Paste the variables (as above).
5. Save the file (Ctrl+O, Enter) and exit (Ctrl+X).

### 5. Apply Changes 

After creating `.Renviron`, restart R or RStudio so the variables are loaded.

Verify in R:

```r
Sys.getenv("DB_HOST")
Sys.getenv("DB_PASSWORD")
```

If it prints your values correctly, the .Renviron file is working.