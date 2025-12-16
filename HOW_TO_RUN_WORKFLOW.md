# How to Run Workflow Manually

## Where to Find "Run workflow" Button

1. **Go to Actions Tab:**
   - In your GitHub repository
   - Click on **"Actions"** tab (top navigation)

2. **Select the Workflow:**
   - In the left sidebar, click **"Terraform CI/CD Pipeline"**
   - You should see a list of workflow runs

3. **Find "Run workflow" Button:**
   - Look at the **top right** of the workflow runs list
   - You should see a blue **"Run workflow"** button
   - It's next to the filter/search options

4. **Run the Workflow:**
   - Click **"Run workflow"** button
   - Select branch: `main`
   - Choose action: `apply` or `destroy`
   - Click the green **"Run workflow"** button

## If You Don't See the Button

**Possible reasons:**
1. **Refresh the page** - Sometimes GitHub UI needs a refresh
2. **Check branch** - Make sure you're viewing the `main` branch
3. **Check permissions** - You need write access to the repository
4. **Browser cache** - Try clearing cache or using incognito mode

## Alternative: Use GitHub CLI

If the button doesn't appear, you can trigger it via command line:

```bash
gh workflow run terraform.yml -f action=apply
```

Or for destroy:
```bash
gh workflow run terraform.yml -f action=destroy
```

## Direct Link

You can also go directly to:
`https://github.com/SrustikGowda/aws-terraform/actions/workflows/terraform.yml`

The "Run workflow" button should be visible there.

