using namespace std;
#include <iostream>
#include  <cstring>

extern "C" int vow_count(char* str1, char* str2);

void compare_count(int count1, int count2);

int main() {
    char line1[256], line2[256];
    char vowels[] = "AEIOUYaeiouy";
    cin.getline(line1, 255);
    cin.getline(line2, 255);
    int count1 = vow_count(vowels, line1);
    int count2 = vow_count(vowels, line2);
    compare_count(count1, count2);
}

void compare_count(int count1, int count2) {
    cout << count1 << " " << count2 << endl;
    if (count2 < count1) {
      cout << "there are more vowels in the FIRST line" << endl;
    } else if (count1 < count2) {
      cout << "there are more vowels in the SECOND line" << endl;
    } else {
      cout << "the same number of vowels" << endl;
    }
}