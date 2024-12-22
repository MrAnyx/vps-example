<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class HelloController extends AbstractController
{
    #[Route('/hello', name: 'app_hello')]
    public function index(): JsonResponse
    {
        return $this->json([
            'message' => 'Welcome to your new controller!',
            'path' => 'src/Controller/HelloController.php',
        ]);
    }

    #[Route('/hello/world', name: 'app_hello_world')]
    public function indexWorld(): JsonResponse
    {
        return $this->json([
            'message' => 'Hello World',
            'path' => 'src/Controller/HelloController.php',
        ]);
    }
}
