﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// 4D:ERP для Беларуси, Дмитрий, 23.11.2014 14:49:28 
	// Подсистемы "Стандартные подсистемы" и "НСИ", №7790
	// {
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТранспортнаяНакладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"ТранспортнаяНакладная", "Транспортная накладная",
						СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТН_Вертикальная") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ТН_Вертикальная", 
			"ТН-2 (вертикальная)", 
			СформироватьПечатнуюФормуТН2(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, Неопределено, Ложь, Ложь));
			
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТН_ВертикальнаяСПриложением") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ТН_ВертикальнаяСПриложением", 
			"ТН-2 (вертикальная) с приложением", 
			СформироватьПечатнуюФормуТН2(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, Неопределено,Истина, Ложь));
			
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТН_Горизонтальная") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ТН_Горизонтальная", 
			"ТН-2 (горизонтальная)", 
			СформироватьПечатнуюФормуТН2(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, Неопределено,Ложь, Истина));
			
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТН_ГоризонтальнаяСПриложением") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ТН_ГоризонтальнаяСПриложением", 
			"ТН-2 (горизонтальная) с приложением", 
			СформироватьПечатнуюФормуТН2(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, Неопределено,Истина, Истина));
		
	КонецЕсли;
	// }
	// 4D
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуТранспортнойНакладной(МассивОбъектов, ОбъектыПечати, КомплектыПечати = Неопределено) Экспорт
	
	ТипДокументов = ТипЗнч(МассивОбъектов[0]);

	Если ТипДокументов <> Тип("ДокументСсылка.ТранспортнаяНакладная") Тогда 
		
		СтруктураВозврата = УправлениеПечатьюУТВызовСервера.ПолучитьТранспортныеНакладныеНаПечать(МассивОбъектов);
		ТранспортныеНакладныеНаПечать = СтруктураВозврата.ТранспортныеНакладныеНаПечать;
		
		Для Каждого Документ Из СтруктураВозврата.МассивДокументовБезНакладных Цикл
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 не создана ""Транспортная накладная"". Печать документа ""Транспортная накладная"" невозможна.'"),
					Документ);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Документ)
					
		КонецЦикла	
			
	Иначе
		ТранспортныеНакладныеНаПечать = МассивОбъектов;	
	КонецЕсли;
	
	ТаблицаНакладныхНаПечать = Новый ТаблицаЗначений;
	ОписаниеТипаТранспортнаяНакладная = Новый ОписаниеТипов("ДокументСсылка.ТранспортнаяНакладная");
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ТранспортнаяНакладная", ОписаниеТипаТранспортнаяНакладная);
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ПорядковыйНомер", ОписаниеТипаЧисло);
	
	ПорядковыйНомер = 0;
	Для Каждого Накладная Из ТранспортныеНакладныеНаПечать Цикл 
		СтрокаТаблицы = ТаблицаНакладныхНаПечать.Добавить();	
		СтрокаТаблицы.ТранспортнаяНакладная = Накладная;
		СтрокаТаблицы.ПорядковыйНомер = ПорядковыйНомер;
		ПорядковыйНомер = ПорядковыйНомер  + 1;
	КонецЦикла;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТРАНСПОРТНАЯ_НАКЛАДНАЯ";
		
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ.ТранспортнаяНакладная");
	ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТранспортнаяНакладная(ТаблицаНакладныхНаПечать);
		
	ЗаполнитьТабличныйДокументТН(
			ТабличныйДокумент,
			ДанныеДляПечати,
			ОбъектыПечати,
			КомплектыПечати);

	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументТН(ТабличныйДокумент, СтруктураДанных, ОбъектыПечати, КомплектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТранспортнаяНакладная");
	
	ТаблицаДанныхДляПечати = СтруктураДанных.ТаблицаРезультата;
	ДанныеСсылкиДокументов = СтруктураДанных.РезультатИменаТоваров.Выбрать();
		
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ТаблицаДанныхДляПечати Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		ПервыйДокумент    = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;
		
		// Если ТТН с доставкой и нашли связанные с доставкой ошибки - перейдем к следующему документу
		СтруктураЗаданиеНаПеревозку = Новый Структура("НеНайденоЗаданиеНаПеревозку,
													  |БолееОдногоВхожденияВЗаданияНаПеревозку,
													  |РаспоряжениеНеПроведено",
													  Ложь,Ложь,Ложь);
		ЕстьОшибкиДоставки = Ложь;
		ЗаполнитьЗначенияСвойств(СтруктураЗаданиеНаПеревозку,ДанныеПечати);
		
		Если СтруктураЗаданиеНаПеревозку.НеНайденоЗаданиеНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не найдено задание на перевозку. 
					|Печать формы 1-Т для документов с доставкой возможна после включения документа в задание на перевозку.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.БолееОдногоВхожденияВЗаданияНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно напечатать форму 1-Т для %1, т.к. найдено более одного задания на перевозку, 
					|в которые включен этот документ.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.РаспоряжениеНеПроведено Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ %1 не проведен. Печать товарно - транспортной накладной не будет выполнена.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если ЕстьОшибкиДоставки Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеПечати.ЕстьНепроведенныеДокументыОснования Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 присутствуют непроведенные документы-основания. Печать транспортной накладной невозможна.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
				
			Продолжить;
			
		КонецЕсли;
				
		ОбластьМакета = Макет.ПолучитьОбласть("ГоризонтальнаяЛицеваяСторона");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
		ОбластьМакетаОборотная = Макет.ПолучитьОбласть("ГоризонтальнаяОборотнаяСторона");
		
		СведенияОГрузополучателе  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата);
		СведенияОГрузоотправитель = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
		СведенияОПеревозчике      = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Перевозчик, ДанныеПечати.Дата);
		СведенияОВодителе         = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		
		ПредставлениеГрузоотправителя = "";
		ПредставлениеПеревозчика      = "";
		Перевозчик                    = "";
		Грузоотправитель              = "";
		
		РеквизитыМакета = Новый Структура;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузополучатель) Тогда 
			Если СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
				Или СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				РеквизитыМакета.Вставить("Пункт2_1", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес"));
			Иначе
				РеквизитыМакета.Вставить("Пункт2_2", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны"));
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузоотправитель) Тогда 
			Если СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес");
				РеквизитыМакета.Вставить("Пункт1_1", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			Иначе
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны");
				РеквизитыМакета.Вставить("Пункт1_2", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			КонецЕсли;
		КонецЕсли;

		
		СтруктураПоиска = Новый Структура("ПорядковыйНомер", ДанныеПечати.ПорядковыйНомер);
		
		ИменаТоваров = "";
		Пока ДанныеСсылкиДокументов.НайтиСледующий(СтруктураПоиска) Цикл								
			ИменаТоваров = ИменаТоваров + ДанныеСсылкиДокументов.НаименованиеВидаНоменклатуры + ", ";
		КонецЦикла;			
		
		Если СтрДлина(ИменаТоваров) >= 2 Тогда
			ИменаТоваров = Лев(ИменаТоваров, СтрДлина(ИменаТоваров) - 2);
		КонецЕсли;
		
		РеквизитыМакета.Вставить("Пункт3_1", ИменаТоваров);
		РеквизитыМакета.Вставить("Пункт6_1", ДанныеПечати.ПунктПогрузки);
		РеквизитыМакета.Вставить("Пункт7_1", ДанныеПечати.ПунктРазгрузки);
		
		МассаБруттоСтрока = НСтр("ru = '%МассаБрутто% кг'");
		МассаБруттоСтрока = СтрЗаменить(МассаБруттоСтрока, "%МассаБрутто%", ДанныеПечати.МассаБрутто);
		
		РеквизитыМакета.Вставить("Пункт6_5", МассаБруттоСтрока);
		
		ОбластьМакета.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		РеквизитыМакета.Очистить();
		
		Если ЗначениеЗаполнено(ДанныеПечати.Перевозчик) Тогда 
			Если СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_1", ПредставлениеПеревозчика);
			Иначе
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_2", ПредставлениеПеревозчика);
			КонецЕсли;
		КонецЕсли;
		
		ПредставлениеВодителя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		
		РеквизитыМакета.Вставить("Пункт10_3", ПредставлениеВодителя);
		
		ГрузоподъемностьВТоннахАвтомобиля      = Формат(ДанныеПечати.ГрузоподъемностьВТоннахАвтомобиля,"");
		ВместимостьВКубическихМетрахАвтомобиля = Формат(ДанныеПечати.ВместимостьВКубическихМетрахАвтомобиля,"");
		
		ИнформацияОбАвтомобиле = ""
			+ ?(ПустаяСтрока(ДанныеПечати.ТипАвтомобиля),"",Строка(ДанныеПечати.ТипАвтомобиля) + ", ")
			+ ?(ПустаяСтрока(ДанныеПечати.МаркаАвтомобиля),"",ДанныеПечати.МаркаАвтомобиля  + ", ")
			+ ?(ПустаяСтрока(ГрузоподъемностьВТоннахАвтомобиля),"",ГрузоподъемностьВТоннахАвтомобиля + " " + НСтр("ru = 'т'")  + ", ")
			+ ?(ПустаяСтрока(ВместимостьВКубическихМетрахАвтомобиля),"",ВместимостьВКубическихМетрахАвтомобиля + " " + НСтр("ru = 'куб. м'"));
		
		ИнформацияОбАвтомобиле = СокрЛП(ИнформацияОбАвтомобиле);
		
		Пока Прав(ИнформацияОбАвтомобиле,1) = "," Цикл
			ИнформацияОбАвтомобиле = Лев(ИнформацияОбАвтомобиле, СтрДлина(ИнформацияОбАвтомобиле)-1)
		КонецЦикла;
		
		РеквизитыМакета.Вставить("Пункт11_1", ИнформацияОбАвтомобиле);
		РеквизитыМакета.Вставить("Пункт11_2", ДанныеПечати.ГосНомерАвтомобиля);
		
		СведенияОЗаказчикеПеревозок = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.ЗаказчикПеревозки, ДанныеПечати.Дата,,ДанныеПечати.БанковскийСчетЗаказчикаПеревозки);

		РеквизитыМакета.Вставить("Пункт15_6", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчикеПеревозок, 
			"ПолноеНаименование,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
				
		РеквизитыМакета.Вставить("Пункт16_1", Грузоотправитель);
		РеквизитыМакета.Вставить("Пункт16_2", Перевозчик);
		
		РеквизитыМакета.Вставить("Пункт16_11", ДанныеПечати.Дата);
		РеквизитыМакета.Вставить("Пункт16_21", ДанныеПечати.Дата);
			
		ОбластьМакетаОборотная.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаОборотная);
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено
		 И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено 
		 И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

// 4D:ERP для Беларуси, Дмитрий, 23.11.2014 14:53:29 
// Локализация печатных форм, №7762
// {
#Область Печать_ТН2

Функция СформироватьПечатнуюФормуТН2(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, КомплектыПечати = Неопределено, Приложение = Ложь, Горизонтальная = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Если Горизонтальная Тогда
		
		Если Приложение Тогда
			ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТН_ГоризонтальнаяСПриложением";
		Иначе	
		    ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТН_Горизонтальная";
		КонецЕсли; 	
		
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
				
	Иначе	
		
		Если Приложение Тогда
			ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТН_ВертикальнаяСПриложением";
		Иначе	
		    ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТН_Вертикальная";
		КонецЕсли; 
		
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
	КонецЕсли;
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТОРГ12(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		Если Приложение Тогда
		
			ЗаполнитьТабличныйДокументТН2_СПриложением(
				ТабличныйДокумент,
				ДанныеДляПечати,
				Горизонтальная,
				ОбъектыПечати,
				ПараметрыПечати,
				КомплектыПечати);
				
		Иначе
				
		    ЗаполнитьТабличныйДокументТН2(
				ТабличныйДокумент,
				ДанныеДляПечати,
				Горизонтальная,
				ОбъектыПечати,
				ПараметрыПечати,
				КомплектыПечати);
				
		КонецЕсли;	
			
		Возврат ТабличныйДокумент;
		
	КонецЦикла;
	
КонецФункции //СформироватьПечатнуюФормуТН2

Процедура ЗаполнитьТабличныйДокументТН2(ТабличныйДокумент, ДанныеДляПечати, Горизонтальная, ОбъектыПечати, ПараметрыПечати, КомплектыПечати)
	
	ТабличныйДокумент.ПолеСлева = 15;
	ТабличныйДокумент.ПолеСнизу = 10;
	ТабличныйДокумент.ПолеСправа = 15;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ЕдиницаИзмеренияВеса           = Константы.ЕдиницаИзмеренияВеса.Получить(); 
	КоэффициентПересчетаВТонны     = НоменклатураСервер.КоэффициентПересчетаВТонны(Константы.ЕдиницаИзмеренияВеса.Получить());

	ДанныеПечати      	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыводитьГТД = ?(ДанныеДляПечати.РезультатПоТабличнойЧасти.Колонки.Найти("НомерГТД") = Неопределено, Ложь, Истина);
	
	Если Горизонтальная Тогда
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТН_Горизонтальная");
	Иначе
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТН_Вертикальная");
	КонецЕсли; 
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
	  	// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;

		// Найдем в выборке товары по текущему документу
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 печать товарной накладной не требуется'"),
					ДанныеПечати.Ссылка);
			Иначе
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют товары. Печать товарной накладной без услуг не требуется'"),
					ДанныеПечати.Ссылка);
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
				
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыШапки(ДанныеПечати, Макет, ТабличныйДокумент, Истина);
				
		НомерСтраницы = 1;
		ИтоговыеСуммы = УправлениеПечатьюУПВызовСервера.СтруктураИтоговыеСуммы();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаб");
		ОбластьМакетаСтандарт   = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		
		ИспользоватьНаборы = Ложь;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВыборкаПоДокументам, "ЭтоНабор") Тогда
			ИспользоватьНаборы = Истина;
			ОбластьМакетаНабор         = Макет.ПолучитьОбласть("СтрокаНабор");
			ОбластьМакетаКомплектующие = Макет.ПолучитьОбласть("СтрокаКомплектующие");
		КонецЕсли;
		
		ВыводШапки = 0;
		
		Если ДанныеДляПечати.РезультатПоШапке.Колонки.Найти("ВыводитьКодНоменклатуры") <> Неопределено Тогда
			ВыводитьКодНоменклатуры = ДанныеПечати.ВыводитьКодНоменклатуры;
		Иначе
			ВыводитьКодНоменклатуры = Истина;
		КонецЕсли;
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		НомерСтроки = 0;
		Пока СтрокаТовары.Следующий() Цикл
		
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаКомплектующие;
			Иначе
				ОбластьМакета = ОбластьМакетаСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ОбластьМакета, Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры, ВыводитьГТД, Истина);
			КонецЕсли;
			
			Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
				ВыводШапки = 1;
			КонецЕсли;
			
			Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
				
				ВыводШапки = 2;
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				СтруктураПараметров.Вставить("Валюта", ?(ДанныеПечати.Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(), "руб. коп.", ДанныеПечати.Валюта));
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакета);
			МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
			Если НомерСтроки = КоличествоСтрок Тогда
				УправлениеПечатьюУПВызовСервера.ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ДанныеПечати.Валюта);
				ОбластьПодвала = УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыПодвала(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны, Истина);
				МассивВыводимыхОбластей.Добавить(ОбластьВсего);
				МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
				ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
				
				УправлениеПечатьюУПВызовСервера.ОбнулитьИтогиПоСтранице(ИтоговыеСуммы);
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				УправлениеПечатьюУПВызовСервера.РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары, ДанныеПечати.Валюта);
			КонецЕсли;
			
		КонецЦикла;
			
		// Выводим итоги по последней странице
		Если НомерСтраницы > 1 Тогда 
			ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
			ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
			ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		КонецЕсли;	
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		УправлениеПечатьюУПВызовСервера.ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ДанныеПечати.Валюта);
		ОбластьПодвала = УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыПодвала(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны, Истина);
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры //ЗаполнитьТабличныйДокументТН2()

Процедура ЗаполнитьТабличныйДокументТН2_СПриложением(ТабличныйДокумент, ДанныеДляПечати, Горизонтальная, ОбъектыПечати, ПараметрыПечати, КомплектыПечати)
	
	ТабличныйДокумент.ПолеСлева = 15;
	ТабличныйДокумент.ПолеСнизу = 10;
	ТабличныйДокумент.ПолеСправа = 15;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ЕдиницаИзмеренияВеса           = Константы.ЕдиницаИзмеренияВеса.Получить(); 
	КоэффициентПересчетаВТонны     = НоменклатураСервер.КоэффициентПересчетаВТонны(Константы.ЕдиницаИзмеренияВеса.Получить());

	ДанныеПечати      	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыводитьГТД = ?(ДанныеДляПечати.РезультатПоТабличнойЧасти.Колонки.Найти("НомерГТД") = Неопределено, Ложь, Истина);
	
	Если Горизонтальная Тогда
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТН_Горизонтальная");
	Иначе
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТН_Вертикальная");
	КонецЕсли; 
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
	  	// Для печати комплектов
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
			КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
			Если КомплектПечатиПоСсылке = Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати[0];
			КонецЕсли;
			Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
				Продолжить
			КонецЕсли;
		КонецЕсли;

		// Найдем в выборке товары по текущему документу
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 печать товарной накладной не требуется'"),
					ДанныеПечати.Ссылка);
			Иначе
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют товары. Печать товарной накладной без услуг не требуется'"),
					ДанныеПечати.Ссылка);
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
				
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыШапки(ДанныеПечати, Макет, ТабличныйДокумент, Истина);
				
		НомерСтраницы = 1;
		ИтоговыеСуммы = УправлениеПечатьюУПВызовСервера.СтруктураИтоговыеСуммы();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаб");
		ОбластьМакетаСтандарт   = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаПриложение = Макет.ПолучитьОбласть("СтрокаПриложение");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		
		ИспользоватьНаборы = Ложь;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВыборкаПоДокументам, "ЭтоНабор") Тогда
			ИспользоватьНаборы = Истина;
			ОбластьМакетаНабор         = Макет.ПолучитьОбласть("СтрокаНабор");
			ОбластьМакетаКомплектующие = Макет.ПолучитьОбласть("СтрокаКомплектующие");
		КонецЕсли;
		
		ВыводШапки = 0;
		
		Если ДанныеДляПечати.РезультатПоШапке.Колонки.Найти("ВыводитьКодНоменклатуры") <> Неопределено Тогда
			ВыводитьКодНоменклатуры = ДанныеПечати.ВыводитьКодНоменклатуры;
		Иначе
			ВыводитьКодНоменклатуры = Истина;
		КонецЕсли;
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
		
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				УправлениеПечатьюУПВызовСервера.РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары, ДанныеПечати.Валюта);
			КонецЕсли;
			
		КонецЦикла;
		
		ОбластьМакетаПриложение.Параметры.Заполнить(ИтоговыеСуммы);
		ОбластьМакетаПриложение.Параметры.Валюта = ДанныеПечати.Валюта;
	    ТабличныйДокумент.Вывести(ОбластьМакетаПриложение);
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		УправлениеПечатьюУПВызовСервера.ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ДанныеПечати.Валюта);
		ОбластьПодвала = УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыПодвала(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны, Истина, Истина);
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		//приложение
		ИтоговыеСуммы = УправлениеПечатьюУПВызовСервера.СтруктураИтоговыеСуммы();
		МассивВыводимыхОбластей.Очистить();
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
        ОбластьПриложение  							= Макет.ПолучитьОбласть("Приложение");
		ОбластьПриложение.Параметры.ДатаДокумента	= Формат(ДанныеПечати.Дата,"ДЛФ=DD");
	    ОбластьПриложение.Параметры.НомерИсходящегоДокумента = ДанныеПечати.НомерИсходящегоДокумента;
		ОбластьПриложение.Параметры.СерияИсходящегоДокумента = ДанныеПечати.СерияИсходящегоДокумента;
		ТабличныйДокумент.Вывести(ОбластьПриложение);
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		НомерСтроки = 0;
		Пока СтрокаТовары.Следующий() Цикл
		
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаКомплектующие;
			Иначе
				ОбластьМакета = ОбластьМакетаСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ОбластьМакета, Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры, ВыводитьГТД, Истина);
			КонецЕсли;
			
			Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
				ВыводШапки = 1;
			КонецЕсли;
			
			Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
				
				ВыводШапки = 2;
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				СтруктураПараметров.Вставить("Валюта", ?(ДанныеПечати.Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(), "руб. коп.", ДанныеПечати.Валюта));
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакета);
			МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
			Если НомерСтроки = КоличествоСтрок Тогда
				УправлениеПечатьюУПВызовСервера.ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ДанныеПечати.Валюта);
				ОбластьПодвала = УправлениеПечатьюУПВызовСервера.ЗаполнитьРеквизитыПодвала(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны, Истина, Истина);
				МассивВыводимыхОбластей.Добавить(ОбластьВсего);
				МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
				ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
				
				УправлениеПечатьюУПВызовСервера.ОбнулитьИтогиПоСтранице(ИтоговыеСуммы);
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				УправлениеПечатьюУПВызовСервера.РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары, ДанныеПечати.Валюта);
			КонецЕсли;
			
		КонецЦикла;
			
		// Выводим итоги по последней странице
		Если НомерСтраницы > 1 Тогда 
			ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
			ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
			ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		КонецЕсли;	
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		ОбластьПриложениеПодвал = Макет.ПолучитьОбласть("ПриложениеПодвал");
		ОбластьПриложениеПодвал.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьПриложениеПодвал);
		
		//поставим количество страниц
		ОбластьПоиска       = ТабличныйДокумент.НайтиТекст("КоличествоСтраниц");	
		ОбластьПоиска.Текст = "Товар согласно приложения на " + Строка(НомерСтраницы) + " стр.";
		
		// Выведем нужное количество экземпляров (при печати комплектов)
		Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
			ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
			Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьКопирования);
			КонецЦикла;
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры //ЗаполнитьТабличныйДокументТН2_СПриложением()

#КонецОбласти
// }
// 4D

#КонецОбласти

#КонецЕсли
