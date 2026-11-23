import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

class CrustApp extends StatelessWidget {
  const CrustApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Crust Food',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final app = child ?? const SizedBox.shrink();
            if (constraints.maxWidth < 600) return app;
            final phoneSize = Size(430, constraints.maxHeight);

            return ColoredBox(
              color: const Color(0xFFE9E7E4),
              child: Center(
                child: Container(
                  key: const ValueKey('app-phone-viewport'),
                  width: phoneSize.width,
                  height: constraints.maxHeight,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 28,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(size: phoneSize),
                    child: app,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
