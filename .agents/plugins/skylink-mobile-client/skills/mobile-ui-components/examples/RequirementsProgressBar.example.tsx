import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export interface ProgressBarProps {
  requiredFields: string[];
  fulfilledFields: string[];
}

export const RequirementsProgressBarExample: React.FC<ProgressBarProps> = ({
  requiredFields,
  fulfilledFields,
}) => {
  const total = Math.max(requiredFields.length, 1);
  const completed = fulfilledFields.filter(f => requiredFields.includes(f)).length;
  const ratio = Math.min(completed / total, 1.0);
  const percentage = Math.round(ratio * 100);

  const getBarColor = () => {
    if (ratio >= 1.0) return '#10B981'; // Xanh lá hoàn thành
    if (ratio >= 0.5) return '#3B82F6'; // Xanh dương đang thu thập
    return '#F59E0B';                   // Cam cần bổ sung
  };

  return (
    <View style={styles.card}>
      <View style={styles.header}>
        <Text style={styles.title}>Mức độ hoàn thiện nhu cầu</Text>
        <Text style={[styles.percent, { color: getBarColor() }]}>
          {completed}/{total} ({percentage}%)
        </Text>
      </View>
      <View style={styles.track}>
        <View style={[styles.fill, { width: `${percentage}%`, backgroundColor: getBarColor() }]} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  card: { padding: 12, backgroundColor: '#FFFFFF', borderRadius: 8, elevation: 2 },
  header: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 6 },
  title: { fontSize: 13, fontWeight: '600', color: '#1F2937' },
  percent: { fontSize: 13, fontWeight: '700' },
  track: { height: 6, backgroundColor: '#E5E7EB', borderRadius: 3, overflow: 'hidden' },
  fill: { height: '100%', borderRadius: 3 },
});
