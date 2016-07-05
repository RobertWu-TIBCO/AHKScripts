AutoTrim,On
#Hotstring O1 Z1 *0 ?0 ; this makes hotstring not appending extra space anymore ! take care if any hotstring relys on a space 2016-04-29   ;#Hotstring O0 ;default appending a space

::/foreach::
(
			for(int i:a)
		{
		 System.out.println(i);
		}
)
::/for::
(
		for (int i = 0; i < a.length; i++) {
		 System.out.println(i);
		
		}
)

::/arrayini::
(
	
		// TODO Auto-generated method stub

		int[] a = new int[10];

		for (int i = 0; i < 6; i++) {

			a[i] = i + 1;
		}

		for (int i = 0; i < a.length; i++) {

			System.out.println(a[i]);
		}
		System.out.println(a + "\n length of a is:" + a.length);

		for (int i : a) {
			System.out.println(i);

		}

	
)