import 'package:flutter/material.dart';
import '../../core/constant/app_constants.dart';

class ControlCard extends StatelessWidget {
  final Widget child;

  const ControlCard({Key? key, required this.child}) : super(key: key);

  
  factory ControlCard.switchControl({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ControlCard(
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  
  factory ControlCard.speedControl({
    required int speed,
    required ValueChanged<int> onSpeedChanged,
  }) {
    return ControlCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speed: $speed',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              min: AppConstants.minSpeed.toDouble(),
              max: AppConstants.maxSpeed.toDouble(),
              divisions: AppConstants.maxSpeed - AppConstants.minSpeed,
              value: speed.toDouble(),
              onChangeEnd: (v) => onSpeedChanged(v.toInt()),
              onChanged: (_) {},
            ),
            Wrap(
              spacing: 8,
              children: List.generate(AppConstants.maxSpeed, (i) {
                final val = i + 1;
                return _SpeedButton(
                  value: val,
                  isSelected: speed == val,
                  onPressed: () => onSpeedChanged(val),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  
  factory ControlCard.timerControl({
    required int timerHours,
    required ValueChanged<int> onTimerChanged,
  }) {
    return ControlCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: timerHours,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: AppConstants.timerOptions.map((hours) {
                return DropdownMenuItem(
                  value: hours,
                  child: Text(hours == 0 ? 'Off' : '$hours hour${hours > 1 ? 's' : ''}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onTimerChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  
  factory ControlCard.brightnessControl({
    required int brightness,
    required ValueChanged<int> onBrightnessChanged,
  }) {
    return ControlCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brightness: $brightness%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              min: AppConstants.minBrightness.toDouble(),
              max: AppConstants.maxBrightness.toDouble(),
              value: brightness.toDouble(),
              onChangeEnd: (v) => onBrightnessChanged(v.toInt()),
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }

  
  factory ControlCard.colorControl({
    required String colorMode,
    required ValueChanged<String> onColorChanged,
  }) {
    return ControlCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Temperature',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: AppConstants.colorWarm, label: Text('Warm')),
                ButtonSegment(value: AppConstants.colorCool, label: Text('Cool')),
                ButtonSegment(value: AppConstants.colorDaylight, label: Text('Daylight')),
              ],
              selected: {colorMode},
              onSelectionChanged: (Set<String> selection) {
                onColorChanged(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: child);
  }
}

class _SpeedButton extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SpeedButton({
    required this.value,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        minimumSize: const Size(45, 36),
      ),
      child: Text('$value'),
    );
  }
}