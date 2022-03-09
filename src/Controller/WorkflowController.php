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
//        $pr = new PullRequest();
//        $prWorkflow = $this->workflows->get($pr, 'pull_request');
//        dump($prWorkflow);

        $post = new BlogPost();
        $postWorkflow = $this->workflows->get($post, 'blog_publishing');
//        dump($postWorkflow);

        dump(
            '1. publish',
            $postWorkflow->can($post, 'publish')
        ); // False

        dump(
            '1. to_review',
            $postWorkflow->can($post, 'to_review')
        ); // True

//        dump(
//            '1. enabled transitions',
//            $postWorkflow->getEnabledTransitions($post)
//        );

//        // Update the currentState on the post
//        try {
//            $postWorkflow->apply($post, 'to_review');
//        } catch (LogicException $exception) {
//            // ...
//        }

//        dump(
//            '2. publish',
//            $postWorkflow->can($post, 'publish')
//        ); // False

//        dump(
//            '2. to_review',
//            $postWorkflow->can($post, 'to_review')
//        ); // True

        return $this->json([
            'message' => 'Welcome to your new controller!',
            'path' => 'src/Controller/WorkflowController.php',
        ]);
    }
}
