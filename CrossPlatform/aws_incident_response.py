import boto3
from datetime import datetime

def snapshot_volumes(instance_id: str, region: str) -> list:
    """Create EBS snapshots for all volumes attached to an EC2 instance"""
    ec2 = boto3.client('ec2', region_name=region)
    volumes = ec2.describe_volumes(
        Filters=[{'Name': 'attachment.instance-id', 'Values': [instance_id]}]
    )
    
    snapshots = []
    for vol in volumes['Volumes']:
        response = ec2.create_snapshot(
            VolumeId=vol['VolumeId'],
            Description=f"Forensic snapshot {datetime.now().isoformat()}",
            TagSpecifications=[{
                'ResourceType': 'snapshot',
                'Tags': [{'Key': 'IncidentID', 'Value': 'IR-001'}]
            }]
        )
        snapshots.append(response['SnapshotId'])
    
    return snapshots

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: aws_incident_response.py <instance-id> <region>")
        sys.exit(1)
        
    print("Creating forensic snapshots...")
    snaps = snapshot_volumes(sys.argv[1], sys.argv[2])
    print(f"Created snapshots: {', '.join(snaps)}")
