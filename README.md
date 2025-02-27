# Lab & Lecture Hall Reservation System

Simplifying resource management in education with an intuitive and seamless scheduling solution.



https://github.com/user-attachments/assets/b880a9bd-f8e0-48be-adb9-eabef85250b7



Welcome to the **Lab & Lecture Hall Reservation System**, a full-stack application designed to streamline scheduling and resource allocation for educational institutions. Built with **Flutter** for the mobile app and the **MERN stack (MongoDB, Express.js, React.js, Node.js)** for the admin panel, this system empowers students, lecturers, and administrators with tailored tools for a smoother academic experience.

---

## ✨ Features

### 👨‍🎓 For Students
- **Effortless Viewing**: Check upcoming lectures and available labs in real-time.
- **Calendar Integration**: Manage your schedule with an intuitive, user-friendly calendar.

### 👩‍🏫 For Lecturers
- **Simplified Scheduling**: Schedule or reschedule classes with ease.
- **Smart Selection**: Choose lecture halls based on availability and class needs.

### 🛠️ For Admins
- **User Management**: Verify users and assign roles seamlessly.
- **Resource Oversight**: Monitor and update hall/lab schedules for optimal usage.

---

## 🛠️ Tech Stack
- **Mobile App**: Flutter (Dart) - Cross-platform, responsive UI.
- **Admin Panel**:  
  - **Frontend**: React.js - Dynamic and interactive interface.  
  - **Backend**: Node.js with Express.js - Robust API and server logic.  
  - **Database**: MongoDB - Flexible and scalable data storage.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/)
- [MongoDB](https://www.mongodb.com/try/download/community)
- Git

### Installation

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/IsuruHet/LLHRS.git
   cd LLHRS
   ```

2. **Set Up the Mobile App**  
   ```bash
   cd lab-reservation-ui-main
   flutter pub get
   flutter run
   ```

3. **Set Up the Admin Panel**  
   - **Backend:**  
     ```bash
     cd LLHRS-Backend-Render-main
     npm install
     npm start
     ```
   - **Frontend:**  
     ```bash
     cd LLHRS-Admin-Panel-main
     npm install
     npm start
     ```

4. **Configure Environment Variables**  
   Create a `.env` file in `LLHRS-Backend-Render-main` with your MongoDB URI and other settings (see `.env.example` if provided).


## 👥 Team
This project was brought to life by:

- **Isuru Hettiarachchi**
- **Hanan Haseem**
- **Shashitha Ashan**
- **Fathima Simaha**
- **Akila Gunawardana**

Special thanks to our supervisor, **Mrs. Vasana Sahabandu**, for her invaluable guidance and support.

---

## 🤝 Contributing
We welcome contributions! Feel free to fork this repo, submit issues, or create pull requests. Check out our **Contributing Guidelines** (create this file if needed) for more details.

---

## 📜 License
This project is licensed under the **MIT License** (or your preferred license).

---

## 📬 Contact
Have questions or suggestions? Reach out to us at `https://github.com/IsuruHet` or open an issue on GitHub!

---

### How to Use:
1. Copy the entire content above.
2. Create a new file named `README.md` in your GitHub repository.
3. Paste this content into `README.md`.
4. Replace placeholders like `IsuruHet`, `LLHRS`, `isurusula@gmail.com`, and the demo video link with your actual details.
5. Commit and push the file to your repository:
   ```bash
   git add README.md
   git commit -m "Add README"
   git push origin main
   
