import 'package:flutter/material.dart';
import '../services/facebook_service.dart';

/// Screen để test Facebook SDK integration (chỉ dùng cho development)
class FacebookTestScreen extends StatefulWidget {
  const FacebookTestScreen({super.key});

  @override
  State<FacebookTestScreen> createState() => _FacebookTestScreenState();
}

class _FacebookTestScreenState extends State<FacebookTestScreen> {
  String _anonymousId = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnonymousId();
  }

  Future<void> _loadAnonymousId() async {
    final id = await FacebookService.instance.getAnonymousId();
    setState(() {
      _anonymousId = id ?? 'Not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook SDK Test'),
        backgroundColor: const Color(0xAE1877F2), // Facebook blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Facebook SDK Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Facebook SDK Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'SDK Initialized',
                      FacebookService.instance.isInitialized,
                    ),
                    const SizedBox(height: 8),
                    Text('Anonymous ID: $_anonymousId'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Event Testing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Testing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // App Events
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('app_activation'),
                      child: const Text('Test App Activation'),
                    ),
                    const SizedBox(height: 8),
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('app_install'),
                      child: const Text('Test App Install'),
                    ),
                    const SizedBox(height: 8),
                    
                    // Compass Events
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('compass_basic'),
                      child: const Text('Test Basic Compass Usage'),
                    ),
                    const SizedBox(height: 8),
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('compass_age'),
                      child: const Text('Test Age Compass Usage'),
                    ),
                    const SizedBox(height: 8),
                    
                    // Screen View
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('screen_view'),
                      child: const Text('Test Screen View'),
                    ),
                    const SizedBox(height: 8),
                    
                    // User Engagement
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testEvent('user_engagement'),
                      child: const Text('Test User Engagement'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // User Properties Testing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Properties Testing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _testUserProperties(),
                      child: const Text('Set Test User Properties'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Utility Functions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Utility Functions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _flushEvents(),
                            child: const Text('Flush Events'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _clearUserData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Clear User Data'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.green : Colors.red,
          size: 20,
        ),
      ],
    );
  }

  Future<void> _testEvent(String eventType) async {
    setState(() => _isLoading = true);
    
    try {
      switch (eventType) {
        case 'app_activation':
          await FacebookService.instance.logAppActivation();
          break;
        case 'app_install':
          await FacebookService.instance.logAppInstall();
          break;
        case 'compass_basic':
          await FacebookService.instance.logCompassUsage(
            compassType: 'basic_compass',
          );
          break;
        case 'compass_age':
          await FacebookService.instance.logCompassUsage(
            compassType: 'age_compass',
            userGender: 'Nam',
            userAge: '1990',
          );
          break;
        case 'screen_view':
          await FacebookService.instance.logScreenView('test_screen');
          break;
        case 'user_engagement':
          await FacebookService.instance.logUserEngagement(
            engagementType: 'button_click',
            additionalParams: {'button_name': 'test_button'},
          );
          break;
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$eventType event logged successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging $eventType: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _testUserProperties() async {
    setState(() => _isLoading = true);
    
    try {
      await FacebookService.instance.setUserProperties(
        gender: 'Nam',
        ageRange: '25_34',
        interests: 'compass,navigation,feng_shui',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User properties set successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting user properties: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _flushEvents() async {
    setState(() => _isLoading = true);
    
    try {
      await FacebookService.instance.flush();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Events flushed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error flushing events: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearUserData() async {
    setState(() => _isLoading = true);
    
    try {
      await FacebookService.instance.clearUserData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data cleared successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
