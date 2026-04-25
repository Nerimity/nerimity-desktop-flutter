import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';
import 'package:nerimity_desktop_flutter/theme/app_theme.dart';
import 'package:signals/signals_flutter.dart';

class ServerMemberList extends StatefulWidget {
  const ServerMemberList({super.key});
  @override
  State<ServerMemberList> createState() => _ServerMemberListState();
}

class _ServerMemberListState extends State<ServerMemberList> with SignalsMixin {
  late final _roleIds = createComputed(() {
    final roles = serverStore.currentServerRoles.value?.values.toList();
    if (roles == null) return [];
    roles.sort((a, b) => (b.order).compareTo(a.order));
    return roles.map((e) => e.id).toList();
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final roleIds = _roleIds.value;
              return ListView.builder(
                itemCount: roleIds.length,
                itemBuilder: (ctx, i) => RoleItem(id: roleIds[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RoleItem extends StatefulWidget {
  final String id;
  const RoleItem({super.key, required this.id});

  @override
  State<RoleItem> createState() => _RoleItemState();
}

class _RoleItemState extends State<RoleItem> with SignalsMixin {
  late final _isHovered = createSignal(false);

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final role = serverStore.currentServerRoles.value?[widget.id];
      if (role == null) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 8.0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              hoverColor: AppTheme.itemHoveredBg,
              borderRadius: BorderRadius.circular(8),
              onHover: (hovering) => _isHovered.value = hovering,
              onTap: () {},
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  spacing: 8,
                  children: [Text(role.name, style: TextStyle(fontSize: 14))],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
