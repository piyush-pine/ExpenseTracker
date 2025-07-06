# Expense Tracker

Expense Tracker is a robust web application designed to help users efficiently manage and analyze their personal or shared expenses. Built with a modular architecture, it supports secure authentication, real-time data analytics, and collaborative expense management.

## Architecture Overview

- **Frontend:** JSP, HTML5, CSS3
- **Backend:** Java Servlets
- **Database:** MySQL
- **Build Tool:** Maven
- **Server:** Apache Tomcat

The application follows a two-tier architecture:
- **Presentation Layer:** User interface for input, visualization, and reporting
- **Data Layer:** MySQL database for persistent storage of users, transactions, and categories[5][11]

## Core Features

- **User Authentication:** Secure login and registration
- **Expense Management:** Add, edit, and delete expenses with details (amount, category, date, description)
- **Income Tracking:** Log and categorize income sources
- **Categorization:** Organize transactions by customizable categories
- **Analytics & Reporting:** Visualize expenses with charts and generate monthly/yearly reports
- **Collaboration:** Share expenses with friends or groups, split bills, and track lent/owed amounts[3]
- **Export:** Download reports in Excel or PDF format for offline use[3]
- **Offline Access:** Core features available without internet connectivity[5]
- **Responsive UI:** Works across desktop and mobile browsers

## System Requirements

- Java 11 or higher
- Apache Tomcat 9+
- MySQL 5.7+
- Maven 3.6+
- Modern web browser

## Installation & Setup

1. **Clone the repository:**
'''[git clone https://github.com/you/expense-tracker.git](https://github.com/piyush-pine/ExpenseTracker.git)'''

2. **Database Setup:**
- Import the provided SQL schema into MySQL.
- Update `db.properties` with your database credentials.

3. **Build the project:**

4. **Deploy to Tomcat:**
- Copy the generated `.war` file to the Tomcat `webapps` directory.
- Start Tomcat and access the app at `http://localhost:8080/expense-tracker/`

## Contribution

- Fork the repository and submit pull requests for new features or bug fixes.
- Please follow the code style guidelines and write unit tests for new modules.

## License

MIT License

---

For questions or support, open an issue or contact the maintainer.


Daily update: 2025-07-06