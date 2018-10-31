USER=opensuse
ssh-keygen -t rsa -P “”
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

cd

JDK=jdk-8u191-linux-x64.tar.gz

tar -xvzf $JDK
rm $JDK
mv jdk* /home/$USER/jdk	

tar -xvzf hadoop-2.7.3.tar.gz
mv hadoop-2.7.3 /home/$USER/hadoop

cd 

echo "export JAVA_HOME=/home/$USER/jdk" >> .bashrc
echo  "export HADOOP_HOME=/home/$USER/hadoop" >> .bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> .bashrc

echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> .bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> .bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> .bashrc
echo 'export HADOOP_YARN_HOME=$HADOOP_HOME' >> .bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >>.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> .bashrc
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"' >>.bashrc

source .bashrc

echo "export JAVA_HOME=/home/$USER/jdk" >> /home/$USER/hadoop/etc/hadoop/hadoop-env.sh

cp /home/$USER/hadoop/etc/hadoop/mapred-site.xml.template /home/$USER/hadoop/etc/hadoop/mapred-site.xml


TEXTA="<property><name>mapreduce.framework.name</name><value>yarn</value></property>" 

sed -i "/<configuration>/a $TEXTA" /home/$USER/hadoop/etc/hadoop/mapred-site.xml


TEXTB="<configuration><property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value><description>The name of the default file system. A URI whose scheme and authority determine the FileSystem implementation.The uri's scheme determines the config property (fs.SCHEME.impl)naming the FileSystem implementation class. The uri's authority is used to determine the host, port, etc. for a filesystem.</description></property></configuration>" 

sed -i "/<configuration>/a $TEXTB" /home/$USER/hadoop/etc/hadoop/core-site.xml


mkdir -p /home/$USER/hadoop/hdfs/namenode
mkdir -p /home/$USER/hadoop/hdfs/datanode


TEXTC="<property><name>dfs.replication</name><value>1</value><description>Default block replication.The actual number of replications can be specified when the file is created. The default is used if replication is not specified in create time.</description></property><property><name>dfs.namenode.name.dir</name><value>file:/home/$USER/hadoop/hdfs/namenode</value></property><property><name>dfs.datanode.data.dir</name><value>file:/home/$USER/hadoop/hdfs/datanode</value></property>" 

sed -i "/<configuration>/a $TEXTC" /home/$USER/hadoop/etc/hadoop/hdfs-site.xml

TEXTD="<property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>" 
 
sed -i "/<configuration>/a $TEXTD" /home/$USER/hadoop/etc/hadoop/yarn-site.xml



