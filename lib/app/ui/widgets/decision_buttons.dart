import 'package:flutter/material.dart';
import 'package:gotale/app/models/choice.dart';

class DecisionButtonLayout extends StatelessWidget {
  final List<Choice> decisions;
  final String layoutStyle;
  final Function(Choice) onDecisionMade;

  const DecisionButtonLayout({
    super.key,
    required this.decisions,
    required this.layoutStyle,
    required this.onDecisionMade,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 400;

    switch (layoutStyle) {
      case 'vertical':
        return _VerticalLayout(
          decisions: decisions,
          onDecisionMade: onDecisionMade,
          isNarrow: isNarrow,
        );
      case 'matrix':
        return _MatrixLayout(
          decisions: decisions,
          onDecisionMade: onDecisionMade,
          isNarrow: isNarrow,
        );
      default:
        return _VerticalLayout(
          decisions: decisions,
          onDecisionMade: onDecisionMade,
          isNarrow: isNarrow,
        );
    }
  }
}

class _VerticalLayout extends StatelessWidget {
  final List<Choice> decisions;
  final Function(Choice) onDecisionMade;
  final bool isNarrow;

  const _VerticalLayout({
    required this.decisions,
    required this.onDecisionMade,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: decisions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isNarrow ? 4.0 : 8.0,
            horizontal: isNarrow ? 4.0 : 8.0,
          ),
          child: _DecisionButton(
            decision: decisions[index],
            onPressed: () => onDecisionMade(decisions[index]),
            isNarrow: isNarrow,
          ),
        );
      },
    );
  }
}

class _MatrixLayout extends StatelessWidget {
  final List<Choice> decisions;
  final Function(Choice) onDecisionMade;
  final bool isNarrow;

  const _MatrixLayout({
    required this.decisions,
    required this.onDecisionMade,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: isNarrow ? 1.2 : 1.5,
        crossAxisSpacing: isNarrow ? 4 : 8,
        mainAxisSpacing: isNarrow ? 4 : 8,
      ),
      itemCount: decisions.length,
      itemBuilder: (context, index) {
        return _DecisionButton(
          decision: decisions[index],
          onPressed: () => onDecisionMade(decisions[index]),
          isNarrow: isNarrow,
        );
      },
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final Choice decision;
  final VoidCallback onPressed;
  final bool isNarrow;

  const _DecisionButton({
    required this.decision,
    required this.onPressed,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isNarrow ? 8 : 12),
            color: theme.colorScheme.secondary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(isNarrow ? 8.0 : 16.0),
              child: (decision.text != null)
                  ? Text(
                      decision.text!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: isNarrow ? 12 : 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text('decision.text == null'),
            ),
          ),
        ),
      ),
    );
  }
}
