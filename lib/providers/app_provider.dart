// lib/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

// ── Demo Provider ─────────────────────────────────────────────────────────────
class DemoProvider extends ChangeNotifier {
  UserModel? _activeUser = demoUsers[0];
  bool _isDark = false;

  UserModel get activeUser => _activeUser ?? demoUsers[0];
  bool get isSignedIn => _activeUser != null;
  bool get isDark => _isDark;

  void signIn(UserModel user) {
    _activeUser = user;
    notifyListeners();
  }

  void logout() {
    _activeUser = null;
    notifyListeners();
  }

  void switchUser(int index) {
    if (index < demoUsers.length) {
      _activeUser = demoUsers[index];
      notifyListeners();
    }
  }

  void switchRole(UserRole role) {
    final matching = demoUsers.where((u) => u.role == role).toList();
    if (matching.isNotEmpty) {
      _activeUser = matching.first;
      notifyListeners();
    }
  }

  void switchDepartment(Department dept) {
    if (_activeUser == null) return;
    final current = _activeUser!;
    _activeUser = UserModel(
      id: current.id,
      name: current.name,
      role: current.role,
      department: dept,
      year: current.year,
      batch: current.batch,
      title: current.title,
      bio: current.bio,
      skills: current.skills,
      email: current.email,
    );
    notifyListeners();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

// ── Announcement Provider ─────────────────────────────────────────────────────
class AnnouncementProvider extends ChangeNotifier {
  List<Announcement> _items = List.from(mockAnnouncements);
  final Set<String> _bookmarked = {};
  AnnouncementCategory? _filterCategory;
  String _searchQuery = '';

  List<Announcement> get items => _filtered;
  Set<String> get bookmarked => _bookmarked;
  AnnouncementCategory? get filterCategory => _filterCategory;
  String get searchQuery => _searchQuery;

  List<Announcement> get _filtered {
    return _items.where((a) {
      final matchCat = _filterCategory == null || a.category == _filterCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          a.title.toLowerCase().contains(q) ||
          a.summary.toLowerCase().contains(q) ||
          a.authorName.toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList()
      ..sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.postedAt.compareTo(a.postedAt);
      });
  }

  List<Announcement> forDept(Department dept) =>
      _items.where((a) => a.isCollegeWide || a.targetDept == dept).toList()
        ..sort((a, b) => b.postedAt.compareTo(a.postedAt));

  bool isBookmarked(String id) => _bookmarked.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarked.contains(id)) {
      _bookmarked.remove(id);
    } else {
      _bookmarked.add(id);
    }
    notifyListeners();
  }

  void setFilter(AnnouncementCategory? cat) {
    _filterCategory = cat;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void addAnnouncement(Announcement a) {
    _items.insert(0, a);
    notifyListeners();
  }
}

// ── Event Provider ────────────────────────────────────────────────────────────
class EventProvider extends ChangeNotifier {
  List<Event> _items = List.from(mockEvents);
  final Set<String> _rsvpd = {};
  EventCategory? _filterCategory;
  String _searchQuery = '';

  List<Event> get items => _filtered;
  Set<String> get rsvpd => _rsvpd;
  EventCategory? get filterCategory => _filterCategory;

  List<Event> get _filtered {
    return _items.where((e) {
      final matchCat = _filterCategory == null || e.category == _filterCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.host.toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Event> forDept(Department dept) =>
      _items.where((e) => e.isCollegeWide || e.targetDept == dept).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  bool isRsvpd(String id) => _rsvpd.contains(id);

  void toggleRsvp(String id) {
    if (_rsvpd.contains(id)) {
      _rsvpd.remove(id);
    } else {
      _rsvpd.add(id);
    }
    notifyListeners();
  }

  void setFilter(EventCategory? cat) {
    _filterCategory = cat;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void addEvent(Event e) {
    _items.insert(0, e);
    notifyListeners();
  }
}

// ── Opportunity Provider ──────────────────────────────────────────────────────
class OpportunityProvider extends ChangeNotifier {
  final List<Opportunity> _items = List.from(mockOpportunities);
  final Set<String> _saved = {};
  final Set<String> _interested = {};
  OpportunityType? _filterType;
  String _searchQuery = '';

  List<Opportunity> get items => _filtered;
  Set<String> get saved => _saved;
  OpportunityType? get filterType => _filterType;

  List<Opportunity> get _filtered {
    return _items.where((o) {
      final matchType = _filterType == null || o.type == _filterType;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          o.company.toLowerCase().contains(q) ||
          o.role.toLowerCase().contains(q) ||
          o.description.toLowerCase().contains(q);
      return matchType && matchSearch;
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  bool isSaved(String id) => _saved.contains(id);
  bool isInterested(String id) => _interested.contains(id);

  void toggleSave(String id) {
    if (_saved.contains(id)) {
      _saved.remove(id);
    } else {
      _saved.add(id);
    }
    notifyListeners();
  }

  void toggleInterest(String id) {
    if (_interested.contains(id)) {
      _interested.remove(id);
    } else {
      _interested.add(id);
    }
    notifyListeners();
  }

  void setFilter(OpportunityType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }
}

// ── People Provider ───────────────────────────────────────────────────────────
class PeopleProvider extends ChangeNotifier {
  final List<Person> _all = List.from(mockPeople);
  UserRole? _filterRole;
  Department? _filterDept;
  String _searchQuery = '';

  List<Person> get items => _filtered;
  UserRole? get filterRole => _filterRole;
  Department? get filterDept => _filterDept;
  String get searchQuery => _searchQuery;

  List<Person> get _filtered {
    return _all.where((p) {
      final matchRole = _filterRole == null || p.role == _filterRole;
      final matchDept = _filterDept == null || p.department == _filterDept;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.department.displayName.toLowerCase().contains(q) ||
          p.skills.any((s) => s.toLowerCase().contains(q)) ||
          (p.batch ?? '').toLowerCase().contains(q);
      return matchRole && matchDept && matchSearch;
    }).toList();
  }

  List<Person> forDept(Department dept) =>
      _all.where((p) => p.department == dept).toList();

  void setRoleFilter(UserRole? role) {
    _filterRole = role;
    notifyListeners();
  }

  void setDeptFilter(Department? dept) {
    _filterDept = dept;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void clearFilters() {
    _filterRole = null;
    _filterDept = null;
    _searchQuery = '';
    notifyListeners();
  }
}
