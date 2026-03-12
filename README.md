# Exercise 2.4(a) – QuaDRiGa Rayleigh Channel Dataset

使用 **QuaDRiGa** 生成無線通道資料集，並作為後續 **GAN-based Channel Modeling** 的訓練資料。

需事先下載QuaDRiGa才可執行

執行時間約10分鐘

---

# Simulation Configuration

本實驗使用以下模擬參數：

| Parameter | Value |
|----------|------|
| Carrier Frequency | 3.5 GHz |
| Transmit Antennas | 1 |
| Receive Antennas | 1 |
| UE Speed | 3 km/h |
| Channel Snapshots | 200001 |
| Scenario | 3GPP 38.901 UMi NLOS |

---

# Scenario Description

### Base Station (Tx)

```
(0 , 0 , 25 m)
```

### User Equipment (Rx) Initial Position

```
(100 , 0 , 1.5 m)
```

使用者以 **3 km/h** 的速度沿著 **linear track** 移動。

通道場景採用：

```
3GPP_38.901_UMi_NLOS
```

此模型適用於：

```
Urban Microcell Non-Line-of-Sight (UMi NLOS)
```

---

# Channel Generation Process

QuaDRiGa 會生成多條 **multipath clusters** 的通道係數：

```
h.coeff
```

其維度為：

```
[Rx Antennas , Tx Antennas , Num Clusters , Num Snapshots]
```

在本實驗中：

```
[1 , 1 , NumClusters , 200001]
```

為了得到 **Rayleigh flat-fading channel**，我們將所有 multipath clusters 的通道係數加總：

```matlab
h_flat = sum(h_coeff , 3);
```

最後將其轉換為一維向量：

```
h_siso
```

此向量包含 **200001 個 Rayleigh channel samples**。

---



# Output Dataset

執行後會生成：

```
rayleigh_channel_dataset.mat
```

資料內容：

```
h_siso : complex channel coefficients
```

資料大小：

```
200001 × 1 complex vector
```

每個元素代表一個 **Rayleigh channel coefficient**。

---

# Channel Verification

為了確認生成的通道符合 Rayleigh fading 特性，可以進行以下檢查。

## Magnitude Plot

```matlab
figure;
plot(abs(h_siso));
xlabel('Snapshot Index');
ylabel('|h|');
title('Magnitude of Generated Rayleigh Channel');
grid on;
```

應該可以觀察到 **隨時間變化的 fading 行為**。

---

## Histogram

```matlab
figure;
histogram(abs(h_siso),50);
xlabel('|h|');
ylabel('Count');
title('Histogram of Channel Magnitude');
grid on;
```

振幅分布應呈現 **右偏分布 (Rayleigh-like distribution)**。

---


# Dataset Usage

本 dataset 將用於 **Exercise 2.4(b)** 的 **GAN-based Channel Modeling**。

GAN 將學習以下通道模型：

```
y = h x + n
```

其中：

| Symbol | Description |
|------|-------------|
| h | Rayleigh channel coefficient |
| x | transmitted QAM symbol |
| n | Gaussian noise |
| y | received signal |

---

# Matlab command window  result 
Scenario: 3GPP_38.901_UMi_NLOS

Parameters   [oooooooooooooooooooooooooooooooooooooooooooooooooo]     0 seconds

Channels     [oooooooooooooooooooooooooooooooooooooooooooooooooo]   441 seconds

Channel vector size: [200001       1]

Dataset saved to rayleigh_channel_dataset.mat

mean(real(h)) = -5.704489e-07

mean(imag(h)) = 1.793618e-07

std(real(h))  = 8.915936e-06

std(imag(h))  = 9.401237e-06

```
