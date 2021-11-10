# Centaurus Portal
___

This design document is a proposal for enhancing the dashboard UI that
allows users to manage Centaurus Cluster, Tenants, Users, and
Quotas in an intuitive way.

## Background
___

User can perform following operation using CLI (i.e. using `kubectl` utility)
* Tenant Operation (Create, List and Delete)
* Create RBAC roles and role bindings for other fine-grained cluster admins

Other features which currently CLI also does not support like:
* Managing Quotas for tenants
* User Management


None of these are reflected in the current version of Dashboard UI. There should be a simplified,
more user-friendly way to manage the cluster, tenants and users.

## Goals
___
To add following features in Centaurus Portal(Dashboard UI)
* Manage Centaurus Cluster
* Tenant management
* User management
* Monitoring 
* Managing Quotas and namespaces

## Features Details
___
#####User Management

![](img_3.png)


### Cluster admin profile
* Create Tenant
* Delete Tenant
* List Tenant
* Monitor health checks & resource utilizations for each and every partition
* Reconfigure Cluster Partitions
* Create RBAC roles and role bindings for other fine-grained cluster admins

![img.png](img.png)


### Tenant admin profile
* Creating other fine-grained tenant admins and regular tenant users
* Monitor health checks & resource utilizations for its own respective tenant within the Centaurus cluster
* List/create/delete users
* Create RBAC roles and role bindings in the tenant
* Manage namespace quotas for a tenant

![](img_1.png)

### Tenant user profile
* Application deployment
* Monitoring and resource utilization according to RBAC

![img_2.png](img_2.png)

## Design details
___
#### 1. IAM service details
*Need to add details*
#### 2. Create Tenant Operation

At the time of a tenant creation, a default tenant admin user is automatically created inside the newly created tenant (tenant bootstrapping). Once done, the default tenant admin can do everything inside the tenant without turning to cluster admin. for any tenant management functions. Essentially, tenant management level privileges are delegated to the tenant admin. role for a tenant.

###### API Used

* Create Tenant
* Create Roles and Rolebinding

###### Work Flow
Create tenant -> Create Role --> Create Service Account --> Get Token --> Map to Username & Password


#### 3. Create User Operation
Need to add details

### Developement Portal Link

***Link***: [Centaurus Portal](https://114.143.207.107:30001/)

***Username***: `admin`

***Password***: `password` 