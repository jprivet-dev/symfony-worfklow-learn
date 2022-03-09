<?php

namespace App\Controller;

use App\Entity\BlogPost;
use App\Entity\PullRequest;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Workflow\Registry;

class WorkflowController extends AbstractController
{
    private $workflows;

    public function __construct(Registry $workflows)
    {
        $this->workflows = $workflows;
    }

    #[Route('/workflow', name: 'app_workflow')]
    public function index(): Response
    {
        $pr = new PullRequest();
        $prWorkflow = $this->workflows->get($pr, 'pull_request');

        dd($prWorkflow);

        $bp = new BlogPost();
        $bpWorkflow = $this->workflows->get($bp, 'blog_publishing');

        dd($bpWorkflow);

        return $this->json([
            'message' => 'Welcome to your new controller!',
            'path' => 'src/Controller/WorkflowController.php',
        ]);
    }
}
