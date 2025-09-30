void bubble_sort(int* aNum, int size);
void swap(int* a, int* b);

int main(void) {
    int arr[5] = { 5, 4, 3, 2, 1 };
    bubble_sort(arr, sizeof(arr));
    return 0;
}

void bubble_sort(int* arr, int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
            }
        }
    }
}

void swap(int* a, int* b) {
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}