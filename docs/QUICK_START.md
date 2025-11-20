# JeduAI Quick Start Guide

Get up and running with JeduAI in 5 minutes!

## 🚀 Quick Setup

### 1. Install Dependencies

```bash
cd jeduai_app1
flutter pub get
```

### 2. Configure Supabase (Optional for Demo)

The app works with mock data out of the box. For production:

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the SQL from `database/setup.sql`
3. Update `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### 3. Run the App

```bash
flutter run
```

## 🎯 Quick Test

### Login Credentials

**Admin Portal:**
- Email: `mpkathir@gmail.com`
- Password: `any`

**Staff Portal:**
- Email: `kathirvel.staff@jeduai.com`
- Password: `any`

**Student Portal:**
- Email: `kathirvel.student@jeduai.com`
- Password: `any`

## 📱 Key Features to Try

### As Staff:
1. Go to **Classes** tab
2. Click **Schedule New**
3. Fill in class details
4. Meeting link is auto-generated
5. Click **Schedule Class**
6. Students are automatically notified!

### As Student:
1. Go to **Classes** tab
2. See **Live** and **Upcoming** classes
3. Click **Enroll** to join a class
4. When live, click **Join Now**

### As Admin:
1. Go to **Classes** tab (new!)
2. Monitor all online classes
3. View live classes
4. Cancel classes if needed

## 🎨 What's New

### Admin Portal
- ✅ **Online Class Monitoring** - New tab to monitor all classes
- ✅ View live, upcoming, and completed classes
- ✅ Cancel classes with notifications
- ✅ Real-time enrollment tracking

### Staff Portal
- ✅ **Auto-Generated Meeting Links** - No manual entry needed
- ✅ **One-Click Copy** - Share links instantly
- ✅ **Student Notifications** - Automatic notifications to all students
- ✅ **Class Code Generation** - Unique codes for each class
- ✅ **Real-Time Class List** - See all your scheduled classes

### Student Portal
- ✅ **Live Class Indicators** - See which classes are live now
- ✅ **One-Click Join** - Join live classes instantly
- ✅ **Enrollment System** - Enroll in classes you want
- ✅ **Notifications** - Get notified when classes start

## 🔥 Try This Flow

1. **Login as Staff** → Create a class with auto-generated link
2. **Login as Student** → See the new class and enroll
3. **Login as Admin** → Monitor the class in the new Classes tab
4. **Back to Staff** → Start the class when it's time
5. **Back to Student** → Join the live class!

## 📚 Next Steps

- Read the [User Guide](USER_GUIDE.md) for detailed features
- Check [API Reference](API_REFERENCE.md) for integration
- See [Deployment Guide](DEPLOYMENT_GUIDE.md) for production

## 🆘 Need Help?

- Check [Troubleshooting](USER_GUIDE.md#troubleshooting)
- View [FAQs](USER_GUIDE.md#faqs)
- Email: support@jeduai.com

---

**Ready to explore?** Start with the Staff portal and create your first online class! 🎓
