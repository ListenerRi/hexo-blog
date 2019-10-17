---
title: 通过打DSDT补丁让黑苹果显示电池状态信息
date: 2019-10-11 16:03:22
categories: translation
tags:
- hackintosh
- osx
- dsdt
- 电池
---

> 翻译自：https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/

> 转载请注明出处

# 背景

因为电脑中的电池硬件与苹果的 SMbus 硬件不兼容，所以在笔记本电脑上运行 OS X 时，我们使用 ACPI 来访问电池状态。一般来说，我建议你使用 `ACPIBatteryManager.kext`，可在这里找到: https://github.com/RehabMan/OS-X-ACPI-Battery-Driver

AppleACPIPlatform 的更高版本无法正确访问 EC（嵌入式控制器）中的字段。由于各种 ACPI 方法（_BIF，_STA，_BST等）失效，这会导致 ACPIBatteryManager 获取电池数据出现问题。尽管可以使用较旧版本的 AppleACPIPlatform（来自 Snow Leopard），但还是希望使用最新版本的AppleACPIPlatform，因为对于具有 Ivy Bridge CPU 的计算机，它可以为这些计算机启用本机电源管理。要使用最新版本，必须更改 DSDT 以符合 Apple 的 AppleACPIPlatform 的限制。

特别是，EC 中大于 8 位的任何字段都必须更改为 8 位。 这包括 16、32、64 甚至更大的字段。

你应该先熟悉 DSDT/SSDT 打补丁的基本知识： http://www.tonymacx86.com/yosemite-laptop-support/152573-guide-patching-laptop-dsdt-ssdts.html

# 已存在的补丁

首先，你的笔记本电脑可能已经有补丁了。请看我的补丁仓库: https://github.com/RehabMan/Laptop-DSDT-Patch

为了使 DSDT 与补丁程序匹配，通常首先需要了解补丁程序的制作方式，以便你知道在 DSDT 中要查找的内容，并且可以将所看到的内容与现有补丁程序进行匹配。补丁集的更改比率很高，不会产生错误，并且似乎在补丁所有需要补丁的字段，这很可能是匹配的（本句原文：A patch set that has a high ratio of changes to patches, creates no errors, and appears to patch all fields that need to be patched is likely a match）。

更多信息: https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/page-333#post-1360697

** 注意不要使用除 `MaciASL` 以外的任何其他程序，包括 `DSDT Editor`，我只在 `MaciASL` 中测试了我的补丁 **

# 其他相关 DSDT 补丁

除了多字节 EC 字段外，还有一些其他 DSDT 问题可能会影响电池状态。这些特定问题并非特定于电池状态，但通常在尝试实现电池状态时首次注意到。

电池代码可能取决于将 Windows 的公认版本用作主机 OS。 要解决此问题，请从 `laptop DSDT patch repository` 中应用 "OS Check Fix" 补丁。 这将导致 DSDT 采取与运行 "Windows 2006" 时相同的操作。你可以更改补丁以实现不同的选择（例如"Windows 2012"）。

另一个常见的问题是，OS X 的 ACPI 实现很难处理使用非零 SyncLevel 声明的 Mutex 对象（有关更多信息，请阅读ACPI规范）。要解决此问题，请从 `laptop DSDT patch repository` 中应用 "Fix Mutex with non-zero SyncLevel" 补丁。

# 技能要求

DSDT 是一个“程序”。 因此，在进行修改时具有一些编程/计算机技能会很有帮助。同样，DSDT 补丁本身也具有自己的语言（在 MaciASL Wiki 中进行了简要说明，可在此处找到：http://sourceforge.net/projects/maciasl/ ）。最后，补丁本身基本上是正则表达式的搜索/替换，因此理解正则表达式（regex）会有帮助。熟悉编译器、编译器错误、有能力确定编译器报告的有关代码错误也很有用。

另外，熟悉 ACPI 也是一个好注意。可以在此处下载规范：https://www.acpica.org/

本指南的目的不是教你基本的编程技巧，正则表达式或 ACPI 语言。

# 打补丁的步骤

我使用了一种相当“机械”的过程来打 DSDT 补丁。我只是寻找那些 OS X 无法处理的部分并机械地转换它。我不会太努力地确定代码的哪些部分实际上将要执行，我只是转换了所有看到的内容。

要继续学习，请从本文中下载示例 DSDT。此特定的 DSDT 示例适用于 HP Envy14。最终的完整补丁可从我的补丁库中以获取 "HP Envy 14"。

首先确定 DSDT 中看起来需要修改的结构。加载 DSDT 文件到 MaciASL 并搜索 `EmbeddedControl`。单个 DSDT 中可以有多个 EmbeddedControl 部分，每个部分都附加了字段声明。

因此，我总是从寻找 embeddedcontrol 开始以找到这种声明。

在示例 DSDT 中，您将找到以下单个 EC 域：
```
    OperationRegion (ECF2, EmbeddedControl, Zero, 0xFF)
```
上面的代码声明了一个 255 字节的 EC 域。

这个域被称为 `ECF2`，所以现在我们要搜索 `'Field (ECF2'`。正如在示例 DSDT 中可以看到的，只有一个结构定义（译者注：下面的代码块）引用了这个域，在其他的 DSDT 中可能有很多。

结构的定义描述了这个 255 字节 EC 域。它们是有关联的，因为这个结构体定义引用了 `ECF2` 这个名字（本句原文：You can tell it is related because the name ECF2 is referred to by the Field.）。可以将其视为 EC 中的一种结构（C程序员的结构）（译者注：可以将上面的代码块看作是声明，下面的代码块看作是定义，这样可能更容易理解一些）。

下一步是检查结构定义中的字段，找到大于 8 位的字段。例如，声明的第一个字段是 `BDN0`，大小为 56 位：
```
   Field (ECF2, ByteAcc, Lock, Preserve)
   {
       Offset (0x10),
       BDN0,   56,
```
这是一个大于 8 位的（56 位）字段, 如果这个字段在 DSDT 中的其他位置被访问，则所有出现这个字段的代码都要修改，如果继续搜索 `"BDN0"` 会找到：
```
   Store (BDN0, BDN)
```
这是在（从结构 ECF2 中）将 BDN0 中的值存储到 BDN 中。当访问大于 32 位的字段时，它们以 Buffer 类型访问。32 位或以下的字段作为整数访问。在更改代码时，这一点很重要。Buffer 还有一些其他工作要做。同样，需要注意到此代码是从 ECF2 中读取的。从 ECF2 中读取和写入这两种操作必须以不同的方式处理。

因此，针对这行代码，我们的目的是一次读 8 位读 7 次将这个 56 位的元素读取到缓冲区，以便将所得缓冲区存储到 BDN 中。我们一会儿再回来看如何修改，现在让我们探索 ECF2 结构定义中的其他字段。

回到 ECF2 的定义的位置，查看 ECF2 定义的其余部分，查找所有大于 8 位的字段，然后针对每个字段搜索 DSDT 的其余部分，以查看它们是否在其他地方被访问。通常对于那些没有被其他地方访问的字段，我们无需执行任何操作。 因此，我们看到的下一个字段是BMN0：
```
   BMN0,   32,
```
如果我们在 DSDT 中搜索 `BMN0`，则只会找到此声明，因此它没有在其他地方被访问，我们可以忽略它。`BMN4` 也可以被忽略。而 `BCT0` 是128位并且在其他地方被访问，就像最初的 `BDN0` 一样：
```
   Store (BCT0, CTN)
```
进一步的搜索将得到以下列表：
```
                        BDN0,   56,
                        BCT0,   128,
                        BDN1,   56,
                        BCT1,   128,
...
                        BDC0,   16,
                        BDC1,   16,
                        BFC0,   16,
                        BFC1,   16,
...
                        BDV0,   16,
                        BDV1,   16,
...
                        BPR0,   16,
                        BPR1,   16,

                        BRC0,   16,
                        BRC1,   16,
                        BCC0,   16,
                        BCC1,   16,
                        CV01,   16,
                        CV02,   16,
                        CV03,   16,
                        CV04,   16,
                        CV11,   16,
                        CV12,   16,
                        CV13,   16,
                        CV14,   16,
...
                        BMD0,   16,
                        BMD1,   16,
                        BPV0,   16,
                        BPV1,   16,
                        BSN0,   16,
                        BSN1,   16,
                        BCV0,   16,
                        BCV1,   16,
                        CRG0,   16,
                        CRG1,   16,
                        BTY0,   32,
                        BTY1,   32,
...
                        CBT0,   16,
                        CBT1,   16,
```
正如你所看到的，此 DSDT 中有很多字段需要处理，并且大小各异，16位，32位，56位和128位。

# 大小为16位和32位的字段

16位和32位的字段最容易处理，所以让我们从这里开始。让我们以上面列表中的第一个16位字段 `BDC0` 为例。我们要做的是更改此字段，以便将其分为两个部分（低字节，高字节）。为此，我们需要提供一个 4 个字符的名称，该名称不得与 `DSDT` 中的任何其他名称冲突，这通常很容易只需删除第一个字母并使用后三个字母。（译者注：把一个大小为 16 的变量，拆分两个大小为 8 的变量，并使用不同的变量名）
```
   // 之前是: BDC0, 16
   DC00, 8,
   DC01, 8,
```
针对它的补丁可以这样写：
```
into device label H_EC code_regex BDC0,\s+16, replace_matched begin DC00,8,DC01,8, end;
```
这个补丁的意思是：在名为 `H_EC` 的 `device` 段中，查找 `BDC0,\s+16`（其中 `\s+` 表示一个或多个空白符号），如果找到了则将其替换为 `DC00,8,DC01,8,`，这有效的将一个字段分成了两个。如果你应用这个补丁，并尝试编译修改后的 DSDT 文件，会发现一些错误，因为依然有代码在引用/访问 `BDC0`（译者注：`BDC0` 已经不存在了，因为被拆成了 `DC00` 和 `DC01`），这些错误实际上在帮助我们找到有哪地方需要修改：
```
   Store (BDC0, Index (DerefOf (Index (Local0, 0x02)), Zero))
   Store (ShiftRight (BDC0, 0x08), Index (DerefOf (Index (Local0, 0x02)), One))
```
正如你所看到的，这段代码依然在读取已经不存在的、被拆成两部分的 `BDC0`。为了使补丁更容易编写，我们使用了一个名叫 `B1B2` 的工具函数，使用如下补丁来定义这个函数：
```
into method label B1B2 remove_entry;
into definitionblock code_regex . insert
begin
Method (B1B2, 2, NotSerialized) { Return(Or(Arg0, ShiftLeft(Arg1, 8))) }\n
end;
```
这个函数接收两个参数：低字节和高字节，并返回一个包含这两个参数的 16 位的值。（译者注：这个函数的作用是我们可以用这个函数来替换代码中所有对 `BDC0` 的引用）

针对上面的代码（译者注：注意是代码，不是补丁），我们想要将它转换成这样：
```
   Store (B1B2(DC00,DC01), Index (DerefOf (Index (Local0, 0x02)), Zero))
   Store (ShiftRight (B1B2(DC00,DC01), 0x08), Index (DerefOf (Index (Local0, 0x02)), One))
```
构建一个补丁来自动执行这个转换，并且其他 16 位字段的补丁也将被应用相同的模式：
（译者注：注意这里使用的是 `replaceall_matched`，而上面使用的是 `replace_matched`，它们的区别从字面及原作者的语义来看前者将对 DSDT 文件中的所有匹配做替换操作，后者只替换一个）
```
into method label GBTI code_regex \(BDC0, replaceall_matched begin (B1B2(DC00,DC01), end;
```
敏锐的读者会注意到，可以对以下代码进行优化（译者注：这里没看懂，估计要结合示例 DSDT 文件内容来看才能理解）：
```
   Store (DC00, Index (DerefOf (Index (Local0, 0x02)), Zero))
   Store (DC01, Index (DerefOf (Index (Local0, 0x02)), One))
```
这种优化只能通过手动进行，通常这是不值得的。这里的目标是提出一种修复此代码的自动化方法，而不是试图过多地手动修改，因为如果我们进行过多的手动更改，我们可能会在代码中引入错误。另外，这种代码很少见（在我修改过的 20 多个 DSDT 中仅在两个 DSDT 中看到了它）。

既然你了解了如何处理 16 位的字段，那么将它们全部转换可能是最简单的。这是针对 16 位 EC 字段的综合补丁：
```
# 16-bit registers
into device label H_EC code_regex BDC0,\s+16 replace_matched begin DC00,8,DC01,8 end;
into device label H_EC code_regex BDC1,\s+16 replace_matched begin DC10,8,DC11,8 end;
into device label H_EC code_regex BFC0,\s+16 replace_matched begin FC00,8,FC01,8 end;
into device label H_EC code_regex BFC1,\s+16 replace_matched begin FC10,8,FC11,8 end;
into device label H_EC code_regex BDV0,\s+16 replace_matched begin DV00,8,DV01,8 end;
into device label H_EC code_regex BDV1,\s+16 replace_matched begin DV10,8,DV11,8 end;
into device label H_EC code_regex BPR0,\s+16 replace_matched begin PR00,8,PR01,8 end;
into device label H_EC code_regex BPR1,\s+16 replace_matched begin PR10,8,PR11,8 end;
into device label H_EC code_regex BRC0,\s+16 replace_matched begin RC00,8,RC01,8 end;
into device label H_EC code_regex BRC1,\s+16 replace_matched begin RC10,8,RC11,8 end;
into device label H_EC code_regex BCC0,\s+16 replace_matched begin CC00,8,CC01,8 end;
into device label H_EC code_regex BCC1,\s+16 replace_matched begin CC10,8,CC11,8 end;
into device label H_EC code_regex CV01,\s+16 replace_matched begin CV10,8,CV11,8 end;
into device label H_EC code_regex CV02,\s+16 replace_matched begin CV20,8,CV21,8 end;
into device label H_EC code_regex CV03,\s+16 replace_matched begin CV30,8,CV31,8 end;
into device label H_EC code_regex CV04,\s+16 replace_matched begin CV40,8,CV41,8 end;
into device label H_EC code_regex CV11,\s+16 replace_matched begin CV50,8,CV51,8 end;
into device label H_EC code_regex CV12,\s+16 replace_matched begin CV60,8,CV61,8 end;
into device label H_EC code_regex CV13,\s+16 replace_matched begin CV70,8,CV71,8 end;
into device label H_EC code_regex CV14,\s+16 replace_matched begin CV80,8,CV81,8 end;
into device label H_EC code_regex HPBA,\s+16 replace_matched begin PBA0,8,PBA1,8 end;
into device label H_EC code_regex HPBB,\s+16 replace_matched begin PBB0,8,PBB1,8 end;
into device label H_EC code_regex BMD0,\s+16 replace_matched begin MD00,8,MD01,8 end;
into device label H_EC code_regex BMD1,\s+16 replace_matched begin MD10,8,MD11,8 end;
into device label H_EC code_regex BPV0,\s+16 replace_matched begin PV00,8,PV01,8 end;
into device label H_EC code_regex BPV1,\s+16 replace_matched begin PV10,8,PV11,8 end;
into device label H_EC code_regex BSN0,\s+16 replace_matched begin SN00,8,SN01,8 end;
into device label H_EC code_regex BSN1,\s+16 replace_matched begin SN10,8,SN11,8 end;
into device label H_EC code_regex BCV0,\s+16 replace_matched begin BV00,8,BV01,8 end;
into device label H_EC code_regex BCV1,\s+16 replace_matched begin BV10,8,BV11,8 end;
into device label H_EC code_regex CRG0,\s+16 replace_matched begin RG00,8,RG01,8 end;
into device label H_EC code_regex CRG1,\s+16 replace_matched begin RG10,8,RG11,8 end;
into device label H_EC code_regex CBT0,\s+16 replace_matched begin BT00,8,BT01,8 end;
into device label H_EC code_regex CBT1,\s+16 replace_matched begin BT10,8,BT11,8 end;
```
并且访问这些字段的所有代码都必须修改：
```
# fix 16-bit methods
into method label GBTI code_regex \(BDC0, replaceall_matched begin (B1B2(DC00,DC01), end;
into method label GBTI code_regex \(BDC1, replaceall_matched begin (B1B2(DC10,DC11), end;
into method label GBTI code_regex \(BFC0, replaceall_matched begin (B1B2(FC00,FC01), end;
into method label GBTI code_regex \(BFC1, replaceall_matched begin (B1B2(FC10,FC11), end;
into method label BTIF code_regex \(BFC0, replaceall_matched begin (B1B2(FC00,FC01), end;
into method label BTIF code_regex \(BFC1, replaceall_matched begin (B1B2(FC10,FC11), end;
into method label ITLB code_regex \(BFC1, replaceall_matched begin (B1B2(FC10,FC11), end;
into method label ITLB code_regex \sBFC0, replaceall_matched begin B1B2(FC00,FC01), end;
into method label _Q09 code_regex \(BRC0, replaceall_matched begin (B1B2(RC00,RC01), end;
into method label _Q09 code_regex \sBFC0\) replaceall_matched begin B1B2(FC00,FC01)) end;
into method label GBTI code_regex \(BDV0, replaceall_matched begin (B1B2(DV00,DV01), end;
into method label GBTI code_regex \(BDV1, replaceall_matched begin (B1B2(DV10,DV11), end;
into method label BTIF code_regex \(BDV0, replaceall_matched begin (B1B2(DV00,DV01), end;
into method label BTIF code_regex \(BDV1, replaceall_matched begin (B1B2(DV10,DV11), end;
into method label GBTI code_regex \(BPR0, replaceall_matched begin (B1B2(PR00,PR01), end;
into method label GBTI code_regex \(BPR1, replaceall_matched begin (B1B2(PR10,PR11), end;
into method label BTST code_regex \sBPR0, replaceall_matched begin B1B2(PR00,PR01), end;
into method label BTST code_regex \sBPR1, replaceall_matched begin B1B2(PR10,PR11), end;
into method label BTST code_regex \(BPR0, replaceall_matched begin (B1B2(PR00,PR01), end;
into method label BTST code_regex \(BPR1, replaceall_matched begin (B1B2(PR10,PR11), end;
into method label BTST code_regex \(BRC0, replaceall_matched begin (B1B2(RC00,RC01), end;
into method label BTST code_regex \(BRC1, replaceall_matched begin (B1B2(RC10,RC11), end;
into method label GBTI code_regex \(BRC0, replaceall_matched begin (B1B2(RC00,RC01), end;
into method label GBTI code_regex \(BRC1, replaceall_matched begin (B1B2(RC10,RC11), end;
into method label _Q09 code_regex \(BRC0, replaceall_matched begin (B1B2(RC00,RC01), end;
into method label GBTI code_regex \(BCC0, replaceall_matched begin (B1B2(CC00,CC01), end;
into method label GBTI code_regex \(BCC1, replaceall_matched begin (B1B2(CC10,CC11), end;
into method label GBTI code_regex \(CV01, replaceall_matched begin (B1B2(CV10,CV11), end;
into method label GBTI code_regex \(CV02, replaceall_matched begin (B1B2(CV20,CV21), end;
into method label GBTI code_regex \(CV03, replaceall_matched begin (B1B2(CV30,CV31), end;
into method label GBTI code_regex \(CV04, replaceall_matched begin (B1B2(CV40,CV41), end;
into method label GBTI code_regex \(CV11, replaceall_matched begin (B1B2(CV50,CV51), end;
into method label GBTI code_regex \(CV12, replaceall_matched begin (B1B2(CV60,CV61), end;
into method label GBTI code_regex \(CV13, replaceall_matched begin (B1B2(CV70,CV71), end;
into method label GBTI code_regex \(CV14, replaceall_matched begin (B1B2(CV80,CV81), end;
into method label BTIF code_regex \(BMD0, replaceall_matched begin (B1B2(MD00,MD01), end;
into method label BTIF code_regex \(BMD1, replaceall_matched begin (B1B2(MD10,MD11), end;
into method label GBTI code_regex \sBMD0\) replaceall_matched begin B1B2(MD00,MD01)) end;
into method label GBTI code_regex \(BMD0, replaceall_matched begin (B1B2(MD00,MD01), end;
into method label GBTI code_regex \sBMD1\) replaceall_matched begin B1B2(MD10,MD11)) end;
into method label GBTI code_regex \(BMD1, replaceall_matched begin (B1B2(MD10,MD11), end;
into method label BTST code_regex \(BPV0, replaceall_matched begin (B1B2(PV00,PV01), end;
into method label BTST code_regex \(BPV1, replaceall_matched begin (B1B2(PV10,PV11), end;
into method label GBTI code_regex \(BPV0, replaceall_matched begin (B1B2(PV00,PV01), end;
into method label GBTI code_regex \(BPV1, replaceall_matched begin (B1B2(PV10,PV11), end;
into method label BTIF code_regex \(BSN0, replaceall_matched begin (B1B2(SN00,SN01), end;
into method label BTIF code_regex \(BSN1, replaceall_matched begin (B1B2(SN10,SN11), end;
into method label GBTI code_regex \(BSN0, replaceall_matched begin (B1B2(SN00,SN01), end;
into method label GBTI code_regex \(BSN1, replaceall_matched begin (B1B2(SN10,SN11), end;
into method label GBTI code_regex \(BCV0, replaceall_matched begin (B1B2(BV00,BV01), end;
into method label GBTI code_regex \(BCV1, replaceall_matched begin (B1B2(BV10,BV11), end;
into method label GBTI code_regex \(CRG0, replaceall_matched begin (B1B2(RG00,RG01), end;
into method label GBTI code_regex \(CRG1, replaceall_matched begin (B1B2(RG10,RG11), end;
into method label GBTI code_regex \(CBT0, replaceall_matched begin (B1B2(BT00,BT01), end;
into method label GBTI code_regex \(CBT1, replaceall_matched begin (B1B2(BT10,BT11), end;
```

现在那些 32 位的字段如 BTY0 和 BTY1 如何处理呢？ 它们与 16 位的字段处理方式差不多，除了我们需要再声明一个名为 B1B4 的函数，它能从四个 8 位的参数中构造出一个 32 位的值：
```
into method label B1B4 remove_entry;
into definitionblock code_regex . insert
begin
Method (B1B4, 4, NotSerialized)\n
{\n
    Store(Arg3, Local0)\n
    Or(Arg2, ShiftLeft(Local0, 8), Local0)\n
    Or(Arg1, ShiftLeft(Local0, 8), Local0)\n
    Or(Arg0, ShiftLeft(Local0, 8), Local0)\n
    Return(Local0)\n
}\n
end;
```
然后我们需要将 BTY0 和 BTY1 转换成 4 个 8 位的字段：
```
# 32-bit registers
into device label H_EC code_regex BTY0,\s+32 replace_matched begin TY00,8,TY01,8,TY02,8,TY03,8 end;
into device label H_EC code_regex BTY1,\s+32 replace_matched begin TY10,8,TY11,8,TY12,8,TY13,8 end;
```
下面这些在 GBTI 函数中的代码需要修改，因为它们引用了 BTY0 和 BYT1：
```
   Store (BTY0, BTY)
...
   Store (BTY1, BTYB)
```
很像针对 16 位字段所做的补丁，但使用的是 `B1B4` 函数：
```
# fix 32-bit methods
into method label GBTI code_regex \(BTY0, replaceall_matched begin (B1B4(TY00,TY01,TY02,TY03), end;
into method label GBTI code_regex \(BTY1, replaceall_matched begin (B1B4(TY10,TY11,TY12,TY13), end;
```
这个补丁将会把上面的代码修改成下面这样：
```
   Store (B1B4(TY00,TY01,TY02,TY03), BTY)
...
   Store (B1B4(TY10,TY11,TY12,TY13), BTYB)
```

# 缓冲字段（大于 32 位的字段）

回到我们最初对大于8位的字段的搜索结果，发现我们有这些大于32位的字段：
```
   BDN0,   56,
   BCT0,   128,
   BDN1,   56,
   BCT1,   128,
```
要一次以 8 位访问这些字段很繁琐，因此我喜欢通过 offset（偏移量） 来访问它们，并确保没有现有的代码直接访问它们，我们使用如下补丁将其重命名：
```
into device label H_EC code_regex (BDN0,)\s+(56) replace_matched begin BDNX,%2,//%1%2 end;
into device label H_EC code_regex (BDN1,)\s+(56) replace_matched begin BDNY,%2,//%1%2 end;
into device label H_EC code_regex (BCT0,)\s+(128) replace_matched begin BCTX,%2,//%1%2 end;
into device label H_EC code_regex (BCT1,)\s+(128) replace_matched begin BCTY,%2,//%1%2 end;
```
接下来，我们需要确定这些字段在结构体 ECF2 内的偏移量。**请记住，大小以位为单位，但偏移量以字节为单位（译者注：这里需要记住）**。我在下面的注释中使用的偏移量以十六进制表示。你可以看看是否能计算出相同的数字。
```
   Field (ECF2, ByteAcc, Lock, Preserve)
   {
            Offset (0x10),
       BDN0,   56,     //!!0x10
            Offset (0x18),
       BME0,   8,
            Offset (0x20),
       BMN0,   32,     //0x20
       BMN2,   8,     //0x24
       BMN4,   88,    //0x25
       BCT0,   128,     //!! 0x30
       BDN1,   56,     //!! 0x40
            Offset (0x48),
       BME1,   8,
            Offset (0x50),
       BMN1,   32,     //0x50
       BMN3,   8,     //0x54
       BMN5,   88,     //0x55
       BCT1,   128,     //!!0x60
```
一旦你运行了上面的补丁并编译，编译器会告诉你哪些地方需要被注意（译者注：编译报错的地方即需要被修改的地方）。在这个例子中，我们会看到下面的错误：
```
...
   Store (BCT0, CTN)
...
   Store (BDN0, BDN)
...
   Store (BCT1, CTNB)
...
   Store (BDN1, BDNB)
...
```
出现这些错误是因为 BCT0, BDN0, BCT1, BDN1 这些字段被我们改了名字。

正如你所看到的，代码在从这些缓冲字段读取并将它们存储在其他位置。为了一次读取这些缓冲字段 8 位数据，我们需要定义其他函数：
```
# utility methods to read/write buffers from/to EC
into method label RE1B parent_label H_EC remove_entry;
into method label RECB parent_label H_EC remove_entry;
into device label H_EC insert
begin
Method (RE1B, 1, NotSerialized)\n
{\n
    OperationRegion(ERAM, EmbeddedControl, Arg0, 1)\n
    Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }\n
    Return(BYTE)\n
}\n
Method (RECB, 2, Serialized)\n
// Arg0 - offset in bytes from zero-based EC\n
// Arg1 - size of buffer in bits\n
{\n
    ShiftRight(Add(Arg1,7), 3, Arg1)\n
    Name(TEMP, Buffer(Arg1) { })\n
    Add(Arg0, Arg1, Arg1)\n
    Store(0, Local0)\n
    While (LLess(Arg0, Arg1))\n
    {\n
        Store(RE1B(Arg0), Index(TEMP, Local0))\n
        Increment(Arg0)\n
        Increment(Local0)\n
    }\n
    Return(TEMP)\n
}\n
end;
```
"RECB" 代表 "读 EC 缓冲区"。它接受两个参数，指示 EC 中的偏移量和希望读取的字段的位大小。以位为单位的大小必须是 8 的倍数。注意，函数中没有检查这个参数。

在此 DSDT 中，比如在名为 H_EC 的 EC 设备（译者注：代码段）中定义这些辅助方法：
```
                Device (H_EC)
                {
                    Name (_HID, EisaId ("PNP0C09"))
```
如果你的 EC 设备（译者注：代码段）名称不同（译者注：不叫 H_EC），则需要更改上面创建 RECB/RE1B 这两个函数的补丁。通常名称为 EC，EC0，在本例中为 H_EC。

为了处理 BCT0 的第一种情况，我们希望修改成这样：
```
   Store(RECB(0x30,128), CTN)
```
`0x30` 是 BTC0 字段（现在称为 BCTX）的偏移量，而 128 是位数。

这些可以通过以下补丁来完成修改：
```
into method label GBTI code_regex \(BCT0, replaceall_matched begin (RECB(0x30,128), end;
into method label GBTI code_regex \(BCT1, replaceall_matched begin (RECB(0x60,128), end;
into method label GBTI code_regex \(BDN0, replaceall_matched begin (RECB(0x10,56), end;
into method label GBTI code_regex \(BDN1, replaceall_matched begin (RECB(0x40,56), end;
```
此 DSDT 没有对 EC 缓冲字段的任何写操作，但如果有，则下面的函数非常有用：
```
into method label WE1B parent_label H_EC remove_entry;
into method label WECB parent_label H_EC remove_entry;
into device label H_EC insert
begin
Method (WE1B, 2, NotSerialized)\n
{\n
    OperationRegion(ERAM, EmbeddedControl, Arg0, 1)\n
    Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }\n
    Store(Arg1, BYTE)\n
}\n
Method (WECB, 3, Serialized)\n
// Arg0 - offset in bytes from zero-based EC\n
// Arg1 - size of buffer in bits\n
// Arg2 - value to write\n
{\n
    ShiftRight(Add(Arg1,7), 3, Arg1)\n
    Name(TEMP, Buffer(Arg1) { })\n
    Store(Arg2, TEMP)\n
    Add(Arg0, Arg1, Arg1)\n
    Store(0, Local0)\n
    While (LLess(Arg0, Arg1))\n
    {\n
        WE1B(Arg0, DerefOf(Index(TEMP, Local0)))\n
        Increment(Arg0)\n
        Increment(Local0)\n
    }\n
}\n
end;
```
假设写入 BCT0 的代码是：
```
   Store(Local0, BCT0)
```
在这种情况下，不能用对 RECB 的调用来代替对 BCT0 的访问。因为这是写操作，而不是读操作。必须使用上面新创建的函数 WECB。
```
   WECB(0x30,128, Local0)
```
WECB 函数的前两个参数与 RECB 相同（EC字段的偏移量和大小）。第三个参数（Arg2）是应写入 EC 字段的值。在这个例子中，是从 Local0 读取数据写入到第一个参数指定的偏移量里。

`Store` 并不是唯一可以执行写操作的 AML 操作码。`Store` 也不是唯一可以执行读操作的 AML 操作码。 例如 `Add` 操作码：
```
   Add(X, Y, Z)
```
上面的示例从X读取，从Y读取，执行加法...并将结果写入Z。

当不确定 AML 操作码的用途时，请阅读 ACPI 规范。在那里有完整的文档，但不在本文讨论范围之内。

文字开头给出的 github 仓库是示例和学习的良好来源。仓库中的现有修补程序中有许多 WECB/RECB 示例。

# 充电/放电状态的逻辑错误(充电器检测)

某些 DSDT 存在逻辑错误，在这种情况下，容量达到 100％（电池充满电）时，`_BST` 返回了错误的状态。这主要影响某些华硕笔记本电脑，但也影响其他一些笔记本电脑。

这是解决此问题的补丁程序：
```
into method label FBST code_regex If\s\(CHGS\s\(Zero\)\)[\s]+\{[\s]+Store\s\(0x02,\sLocal0\)[\s]+\}[\s]+Else[\s]+\{[\s]+Store\s\(One,\sLocal0\)[\s]+\} replaceall_matched begin
If (CHGS (Zero))\n
{\n
     Store (0x02, Local0)\n
}\n
Else\n
{\n
     Store (Zero, Local0)\n
}
end;
```

# 错误报告

下载 patchmatic: https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads/RehabMan-patchmatic-2015-0107.zip

从 zip 中解压出 'patchmatic' 二进制文件. 复制到 `/usr/bin`, 即最终的文件位置是：`/usr/bin/patchmatic`.

在终端中：
```
if [ -d ~/Downloads/RehabMan ]; then rm -R ~/Downloads/RehabMan; fi
mkdir ~/Downloads/RehabMan
cd ~/Downloads/RehabMan
patchmatic -extract
```
注意：如果使用复制/粘贴而不是手动键入命令，会更容易。

将 `~/Downloads/RehabMan` 目录打包成 zip 文件。

另外将 `ioreg` 也打包成 zip：http://www.tonymacx86.com/audio/58368-guide-how-make-copy-ioreg.html. 注意要用帖子中提到的 `IORegistryExplorer v2.1`！不要使用其他版本的 `IORegistryExplorer.app`。

还有以下命令的输出：
```
kextstat|grep -y acpiplat
kextstat|grep -y appleintelcpu
kextstat|grep -y applelpc
```
还有打包成 zip 的 `EFI/Clover` 目录（在打包前先在 Clover 界面按一下 F4）。注意要删除 'themes' 目录，尤其是如果你安装了很多主题，还有只需要提供 `EFI/Clover` 而不是整个 `EFI` 目录。

还有以下命令的输出：
```
sudo touch /System/Library/Extensions && sudo kextcache -u /
```
再把上面提到的所有内容打包成一个大的 zip 文件并发布到帖子里。不要使用外部链接，使用编辑帖子时的上传文件功能。

# 贡献

如果你确实完成了给你的电池方法打补丁，建议你将你的补丁和你的电脑信息共享出来，让其他与你是同样配置的人也能使用你的补丁，我可以将你的补丁程序添加到上面提到的 github 仓库中。请同时提供包含补丁和本机 DSDT 的文本文件（以便我能够根据本机 DSDT 查看补丁程序）。只有可以将补丁应用到本机 DSDT上时，我才会将这个补丁添加到仓库中。

译者注：示例 DSDT 文件请从原文中下载。