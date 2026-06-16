import os
from decimal import Decimal

import boto3

from catalog_seed import SEED_PRODUCTS


def to_dynamodb_item(product):
    item = dict(product)
    item["price"] = Decimal(str(product["price"]))
    item["stock"] = int(product["stock"])
    return item


def main():
    region = os.environ.get("AWS_REGION", "us-east-1")
    table_name = os.environ["DYNAMODB_TABLE"]
    table = boto3.resource("dynamodb", region_name=region).Table(table_name)

    seeded = 0
    for product in SEED_PRODUCTS:
        table.put_item(Item=to_dynamodb_item(product))
        seeded += 1

    print(f"Seeded {seeded} products into {table_name} in {region}")


if __name__ == "__main__":
    main()
