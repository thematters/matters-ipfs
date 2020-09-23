# matters-ipfs

## Running IPFS inside Docker

### Start

Start daemon with enabled automatic periodic repo garbage collection.

```bash
docker-compose up -d
```

### Stop

```bash
docker-compose down
```

### Garbage collection manually

```bash
docker-compose exec daemon ipfs repo gc
```

## Upsizing EBS

### Identifying the file system for a volume

```bash
df -hT
```

### Extending a partition 

```bash
sudo growpart /dev/nvme0n1 1
```

### Extending the file system

```bash
sudo resize2fs /dev/nvme0n1p1
```

### References
- [Extending a Linux file system after resizing a volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html)

## Setup AWS Cloudwatch Memory and Drive Monitoring

### Install the required packages on Ubuntu

```bash
sudo apt-get update
sudo apt-get install unzip
sudo apt-get install libwww-perl libdatetime-perl
```

### Install monitoring scripts

```bash
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O

unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \
cd aws-scripts-mon
```

### Test Run without posting data to CloudWatch

```bash
./mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-space-avail --disk-space-used --disk-path=/ --verify --verbose --aws-access-key-id=AWS_ACCESS_KEY_ID --aws-secret-key=AWS_ACCESS_KEY
```

### Report to Cloudwatch Periodically

```bash
crontab -e
```

```bash
*/5 * * * * /home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-space-avail --disk-space-used --disk-path=/ --from-cron --aws-access-key-id=AWS_ACCESS_KEY_ID --aws-secret-key=AWS_ACCESS_KEY
```

### References
- [Monitoring memory and disk metrics for Amazon EC2 Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html)
- [Setup AWS Cloudwatch Memory and Drive Monitoring on RHEL](https://www.bonusbits.com/wiki/HowTo:Setup_AWS_Cloudwatch_Memory_and_Drive_Monitoring_on_RHEL)
