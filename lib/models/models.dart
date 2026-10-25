// lib/models/models.dart
// All data models for Sairam LinkUp

enum UserRole { student, staff, alumni }
enum Department {
  cse, ece, me, ce, it, eee;

  String get displayName {
    switch (this) {
      case Department.cse: return 'Computer Science & Engineering';
      case Department.ece: return 'Electronics & Communication Engineering';
      case Department.me: return 'Mechanical Engineering';
      case Department.ce: return 'Civil Engineering';
      case Department.it: return 'Information Technology';
      case Department.eee: return 'Electrical Engineering';
    }
  }

  String get shortName {
    switch (this) {
      case Department.cse: return 'CSE';
      case Department.ece: return 'ECE';
      case Department.me: return 'ME';
      case Department.ce: return 'CE';
      case Department.it: return 'IT';
      case Department.eee: return 'EEE';
    }
  }
}

enum AnnouncementCategory { academic, cultural, technical, career, general, exam, placement, event }
enum EventCategory { workshop, cultural, technical, career, sports, academic, department }
enum OpportunityType { internship, fullTime, partTime, research }

// ── User Model ──────────────────────────────────────────────────────────────
class UserModel {
  final String id;
  final String name;
  final UserRole role;
  final Department department;
  final String? year;
  final String? batch;
  final String? title;
  final String? bio;
  final List<String> skills;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    this.year,
    this.batch,
    this.title,
    this.bio,
    this.skills = const [],
    required this.email,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  String get roleLabel {
    switch (role) {
      case UserRole.student: return 'Student';
      case UserRole.staff: return 'Staff';
      case UserRole.alumni: return 'Alumni';
    }
  }
}

// ── Announcement Model ───────────────────────────────────────────────────────
class Announcement {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String authorName;
  final String authorDept;
  final AnnouncementCategory category;
  final bool isCollegeWide;
  final Department? targetDept;
  final DateTime postedAt;
  final bool isPinned;

  const Announcement({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.authorName,
    required this.authorDept,
    required this.category,
    required this.isCollegeWide,
    this.targetDept,
    required this.postedAt,
    this.isPinned = false,
  });

  String get categoryLabel {
    switch (category) {
      case AnnouncementCategory.academic: return 'Academic';
      case AnnouncementCategory.cultural: return 'Cultural';
      case AnnouncementCategory.technical: return 'Technical';
      case AnnouncementCategory.career: return 'Career';
      case AnnouncementCategory.general: return 'General';
      case AnnouncementCategory.exam: return 'Exam';
      case AnnouncementCategory.placement: return 'Placement';
      case AnnouncementCategory.event: return 'Event';
    }
  }
}

// ── Event Model ──────────────────────────────────────────────────────────────
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String venue;
  final String host;
  final EventCategory category;
  final Department? targetDept;
  final bool isCollegeWide;
  final String? registrationLink;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.host,
    required this.category,
    this.targetDept,
    this.isCollegeWide = true,
    this.registrationLink,
  });

  String get categoryLabel {
    switch (category) {
      case EventCategory.workshop: return 'Workshop';
      case EventCategory.cultural: return 'Cultural';
      case EventCategory.technical: return 'Technical';
      case EventCategory.career: return 'Career';
      case EventCategory.sports: return 'Sports';
      case EventCategory.academic: return 'Academic';
      case EventCategory.department: return 'Department';
    }
  }
}

// ── Opportunity Model ────────────────────────────────────────────────────────
class Opportunity {
  final String id;
  final String company;
  final String role;
  final OpportunityType type;
  final String description;
  final String eligibility;
  final List<Department> eligibleDepts;
  final String location;
  final String workMode;
  final DateTime deadline;
  final String? packageInfo;
  final String stipend;

  const Opportunity({
    required this.id,
    required this.company,
    required this.role,
    required this.type,
    required this.description,
    required this.eligibility,
    required this.eligibleDepts,
    required this.location,
    required this.workMode,
    required this.deadline,
    this.packageInfo,
    this.stipend = '',
  });

  String get typeLabel {
    switch (type) {
      case OpportunityType.internship: return 'Internship';
      case OpportunityType.fullTime: return 'Full-time';
      case OpportunityType.partTime: return 'Part-time';
      case OpportunityType.research: return 'Research';
    }
  }

  bool get isExpired => deadline.isBefore(DateTime.now());
}

// ── Timetable Model ──────────────────────────────────────────────────────────
class TimetableEntry {
  final String day;
  final String time;
  final String subject;
  final String subjectCode;
  final String room;
  final String faculty;
  final Department department;
  final int year;

  const TimetableEntry({
    required this.day,
    required this.time,
    required this.subject,
    required this.subjectCode,
    required this.room,
    required this.faculty,
    required this.department,
    required this.year,
  });
}

// ── Person Model ─────────────────────────────────────────────────────────────
class Person {
  final String id;
  final String name;
  final UserRole role;
  final Department department;
  final String? year;
  final String? batch;
  final String? title;
  final String? bio;
  final List<String> skills;
  final String email;

  const Person({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    this.year,
    this.batch,
    this.title,
    this.bio,
    this.skills = const [],
    required this.email,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  String get roleLabel {
    switch (role) {
      case UserRole.student: return 'Student';
      case UserRole.staff: return 'Staff';
      case UserRole.alumni: return 'Alumni';
    }
  }

  String get subtitle {
    if (role == UserRole.staff) return title ?? department.shortName;
    if (role == UserRole.alumni) return 'Batch ${batch ?? "N/A"} · ${department.shortName}';
    return 'Year ${year ?? "?"} · ${department.shortName}';
  }
}

// ── Department Info Model ────────────────────────────────────────────────────
class DepartmentInfo {
  final Department dept;
  final String description;
  final String established;
  final int studentCount;
  final int facultyCount;
  final List<String> programs;
  final List<String> labs;
  final String hod;

  const DepartmentInfo({
    required this.dept,
    required this.description,
    required this.established,
    required this.studentCount,
    required this.facultyCount,
    required this.programs,
    required this.labs,
    required this.hod,
  });
}
