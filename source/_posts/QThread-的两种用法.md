---
title: QThread 的两种用法
date: 2019-03-16 14:18:44
categories: qt
tags:
- QThread
---

QThread 官方文档中介绍了的两种用法：

- worker-object
- subclass

# worker-object

引用官方文档中的代码：

``` c++
// worker 类
// 声明了一个信号，一个槽
class Worker : public QObject
{
    Q_OBJECT

public slots:
    void doWork(const QString &parameter) {
        QString result;
        /* ... here is the expensive or blocking operation ... */
        emit resultReady(result);
    }

signals:
    void resultReady(const QString &result);
};

// 控制器类
// 运行中主线程，用于管理 worker 对象和 QThread 对象
// 也声明了一个信号，一个槽
class Controller : public QObject
{
    Q_OBJECT
    QThread workerThread;
public:
    Controller() {
        Worker *worker = new Worker;
        worker->moveToThread(&workerThread);
        connect(&workerThread, &QThread::finished, worker, &QObject::deleteLater);
        connect(this, &Controller::operate, worker, &Worker::doWork);
        connect(worker, &Worker::resultReady, this, &Controller::handleResults);
        workerThread.start();
    }
    ~Controller() {
        workerThread.quit();
        workerThread.wait();
    }
public slots:
    void handleResults(const QString &);
signals:
    void operate(const QString &);
};
```

在 worker 类中的槽函数是真正在子线程中工作的内容，而 worker 那个信号被发出时则表示工作完成，控制器中与之连接的槽函数的作用就是处理 worker 对象在完成工作之后使用其信号发出来的数据，控制器中的那个信号被发出时则是命令 worker 对象开始工作。因此需要使用下面的代码让 worker 对象在线程中开始工作：

``` c++
// Note: 不要在主线程中以调用 worker->doWork() 函数的方式让 worker 开始工作
// 否则将会导致主线程阻塞在这个调用上，只能使用信号-槽的方式：

Controller *controller = new Controller;
emit controller->operate("some string");
```

看起来 worker 对象和 QThread 的对象并没有什么关系，那么 worker 对象是怎么在后台工作的呢？关键的一句代码是：

``` c++
worker->moveToThread(&workerThread);
```

其中`moveToThread`方法是在 QObject 类中定义的，这意味着所有继承了 QObject 类的对象都可以调用这个方法来改变与自身关联的线程，使用下面的代码可以将 worker 对象再转移回主线程中：

``` c++
worker->moveToThread(QApplication::instance()->thread());
```

# subclass

引用官方文档中的代码：

``` c++
// 继承 QThread 并重写其 run 方法
class WorkerThread : public QThread
{
    Q_OBJECT
    void run() override {
        QString result;
        /* ... here is the expensive or blocking operation ... */
        emit resultReady(result);
    }
signals:
    void resultReady(const QString &s);
};

// 启动子线程的方法
// 一般位于主线程中
void MyObject::startWorkInAThread()
{
    WorkerThread *workerThread = new WorkerThread(this);
    connect(workerThread, &WorkerThread::resultReady, this, &MyObject::handleResults);
    connect(workerThread, &WorkerThread::finished, workerThread, &QObject::deleteLater);
    workerThread->start();
}
```

可以看到 subclass 方式是很不同的异步/多线程实现方法，当启动 WorkerThread 这个线程对象时，run 方法将在子线程中调用并执行，直到完成后发出 resultReady 信号将结果交给主线程处理，这没有什么需要解释的细节。

# 总结

这两种用法的区别还是很大的，总的来说 worker-object 方式更为灵活，应用到的场景也较为广泛，如果需要在线程运行过程中不断地与之交互、通讯，则应该使用这种方式；subclass 在实现起来简单，但限制比较大在线程运行期间无法调整其资源状态（或者说不安全）。另外对 QThread 还有一些事情需要牢记，下面是官方的一些描述：

> It is important to remember that a QThread instance lives in the old thread that instantiated it, not in the new thread that calls run(). This means that all of QThread's queued slots will execute in the old thread. Thus, a developer who wishes to invoke slots in the new thread must use the worker-object approach; new slots should not be implemented directly into a subclassed QThread.\
> When subclassing QThread, keep in mind that the constructor executes in the old thread while run() executes in the new thread. If a member variable is accessed from both functions, then the variable is accessed from two different threads. Check that it is safe to do so.

大概意思是说，QThread 对象是始终位于初始化它的那个线程中的（一般是指主线程），这意味着 QThread 对象中的成员和方法是不能（最好不要）直接在主线程中访问的，这也是上面说道 subclass 方式限制比较大的原因。
