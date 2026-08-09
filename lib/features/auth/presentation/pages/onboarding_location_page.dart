import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/app_text_field.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/auth/presentation/providers/signup_profile_provider.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';

const List<String> _kLocations = [
  'United States',
  'United Kingdom',
  'Canada',
  'Australia',
  'Pakistan',
  'United Arab Emirates',
  'Other',
];

class OnboardingLocationPage extends ConsumerStatefulWidget {
  const OnboardingLocationPage({super.key});

  @override
  ConsumerState<OnboardingLocationPage> createState() => _OnboardingLocationPageState();
}

class _OnboardingLocationPageState extends ConsumerState<OnboardingLocationPage> {
  String? _selectedLocation;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedLocation = ref.read(signupProfileProvider).location;
  }

  Future<void> _onNext() async {
    if (_selectedLocation == null || _isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    ref.read(signupProfileProvider.notifier).update(
          (p) => p.copyWith(location: _selectedLocation),
        );

    final result = await ref.read(signupProfileProvider.notifier).submit();

    if (!mounted) return;

    result.when(
      onSuccess: (_) {
        // ignore: unused_result
        ref.read(appInitializationProvider.notifier).refresh();
        context.go(RouteNames.home);
      },
      onFailure: (failure) {
        setState(() {
          _isSubmitting = false;
          _error = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 4,
      totalSteps: 5,
      bottomButton: GradientButton(
        label: 'Next',
        isLoading: _isSubmitting,
        onPressed: _selectedLocation != null ? _onNext : null,
        height: 48.h,
        borderRadius: 10.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Where do you live?', 
            textAlign: TextAlign.center, 
            style: AppTextStyles.pageTitle
          ),
          SizedBox(height: 12.h),
          Text(
            "This helps us find you more relevant content. It won't be "
            "visible on your profile.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 24.h),
          AppDropdownField<String>(
            hintText: 'Choose',
            value: _selectedLocation,
            items: _kLocations
                .map((location) => DropdownMenuItem(value: location, child: Text(location)))
                .toList(),
            onChanged: (value) => setState(() => _selectedLocation = value),
          ),
          if (_error != null) ...[
            SizedBox(height: 12.h),
            Text(_error!, textAlign: TextAlign.center, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}
