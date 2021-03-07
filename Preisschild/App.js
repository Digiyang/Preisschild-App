/**
 * Sample B React Native App
 */

import React from 'react';
import {

  StyleSheet,
  View,
  Text
} from 'react-native';

const App: () => React$Node = () => {
  return (
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Bakery Shop</Text>
            </View>
  );
};

const styles = StyleSheet.create({

  sectionContainer: {
    paddingHorizontal: 24,
    backgroundColor: 'red',
    justifyContent: 'flex-start',
    flex: 1,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: 'black',
    textAlign: 'center',
  },
});

export default App;
