﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//
	ЦиклОбмена 	= Параметры.ЦиклОбмена;
	ПечатныеДокументы = Параметры.ПечатныеДокументы;
	ВидПечати = Параметры.ВидПечати;
	ЭтоВебКлиент = Параметры.ЭтоВебКлиент;
		
	// Инициализируем начальные установки
	сохрКоличествоКопий = ХранилищеОбщихНастроек.Загрузить("ПредварительныйПросмотрПечатныхФорм_ПредпросмотрПечатныхЛистовКоличествоКопий");
	Если сохрКоличествоКопий = Неопределено ИЛИ сохрКоличествоКопий = 0 Тогда
		КоличествоКопий = 1;
	Иначе
		КоличествоКопий = сохрКоличествоКопий;
	КонецЕсли;
	
	Для Каждого ПечатныйДокумент Из ПечатныеДокументы Цикл
		НовСтр2 = СписокОбъектовДляПечати.Добавить();
		НовСтр2.Объект = ПечатныйДокумент.Представление;
		НовСтр2.Пометка = Истина;
		Если ПечатныйДокумент.Значение <> Неопределено Тогда 
			ГУИД = Новый УникальныйИдентификатор;
			НовСтр2.ТабличныйДокумент = ПоместитьВоВременноеХранилище(ПечатныйДокумент.Значение, ГУИД);
		КонецЕсли;
	КонецЦикла;
	
	СоответствиеЛистовСписку = Новый Структура;
	
	// Скрываем панель выбора документов, если документ один
	Если ПечатныеДокументы.Количество() = 1 Тогда
		ЭтаФорма.Заголовок = ПечатныеДокументы[0].Представление;
		Элементы.СписокЛистов.Видимость = Ложь;
		ОсвежитьВыбранныйЛист(НовСтр2.ТабличныйДокумент, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СписокОбъектовДляПечати.Количество() = 0 Тогда
		ПоказатьПредупреждение(,"Не выбраны листы для вывода на печать!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ВидПечати = "ПечататьСразу" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Устанавливаем курсор на последний протокол
	Элементы.СписокЛистов.ТекущаяСтрока = 
		СписокОбъектовДляПечати[СписокОбъектовДляПечати.Количество()-1].ПолучитьИдентификатор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ИтоговаяТаблицаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ЦиклОбмена) Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ИтоговаяТаблицаОбработкаРасшифровкиЗавершение", ЭтотОбъект, Расшифровка);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПечать(Команда)
	
	СохранитьНастройки();
	
	Для Каждого Эл Из СписокОбъектовДляПечати Цикл
		Если НЕ Эл.Пометка Тогда
			Продолжить;
		КонецЕсли;
		Для Сч = 1 По КоличествоКопий Цикл
			ЭлТабличныйДокумент = ПолучитьИзВременногоХранилища(Эл.ТабличныйДокумент);
			ЭлТабличныйДокумент.КоличествоЭкземпляров = 1;
			ЭлТабличныйДокумент.ЭкземпляровНаСтранице = 1;
			ЭлТабличныйДокумент.Напечатать();
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВФорматеMicrosoftExcel(Команда)
	
	ВыгрузитьНаДиск(ТипФайлаТабличногоДокумента.XLS);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВВидеТабличныхДокументов(Команда)
	
	ВыгрузитьНаДиск(ТипФайлаТабличногоДокумента.MXL);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокЛистовПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ОсвежитьВыбранныйЛист(Элемент.ТекущиеДанные.ТабличныйДокумент, Элементы.СписокЛистов.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ХранилищеОбщихНастроек.Сохранить("ПредварительныйПросмотрПечатныхФорм_ПредпросмотрПечатныхЛистовКоличествоКопий",, КоличествоКопий);
	
КонецПроцедуры

&НаСервере
Процедура ОсвежитьВыбранныйЛист(АдресТД, ИДСтроки=0)
	
	Если ЗначениеЗаполнено(АдресТД) Тогда
		
		ВыводимыйТаблДок = ПолучитьИзВременногоХранилища(АдресТД);
		ВыводимыйТаблДок.ОриентацияСтраницы = ВыводимыйТаблДок.ОриентацияСтраницы;
		ВыводимыйТаблДок.АвтоМасштаб = ВыводимыйТаблДок.АвтоМасштаб;
		Если НЕ ВыводимыйТаблДок.АвтоМасштаб Тогда
			ВыводимыйТаблДок.МасштабПечати = ВыводимыйТаблДок.МасштабПечати;
		КонецЕсли;
		ВыводимыйТаблДок.ТолькоПросмотр = Ложь;
		ВыводимыйТаблДок.ПолеСверху = ВыводимыйТаблДок.ПолеСверху;
		ВыводимыйТаблДок.ПолеСнизу = ВыводимыйТаблДок.ПолеСнизу;
		ВыводимыйТаблДок.ПолеСправа = ВыводимыйТаблДок.ПолеСправа;
		ВыводимыйТаблДок.ПолеСлева = ВыводимыйТаблДок.ПолеСлева;
		ИтоговаяТаблица = ВыводимыйТаблДок;
		
	Иначе
		
		Если ЭтоВебКлиент Тогда
			
			Элементы.ИтоговаяТаблица.ТолькоПросмотр = Истина;
			ТД = Новый ТабличныйДокумент;
			
			КолСтрокВГруппе = СписокОбъектовДляПечати.Количество();
			Отступ			= 10;
			Интервал		= 16;
			ШиринаРисунка	= 24;
			ВысотаРисунка	= 30;
			РисунковВСтроке	= 4;
			ТД.Область().ЦветФона = Новый Цвет(255, 251, 240);
			
			Для Инд = 0 По КолСтрокВГруппе - 1 Цикл
				
				ТекСтр = СписокОбъектовДляПечати[Инд];
				
				ТекТаблДок = ПолучитьИзВременногоХранилища(ТекСтр.ТабличныйДокумент);
				
				НовРис = ТД.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Текст);
				НовРис.Узор = ТипУзораТабличногоДокумента.Сплошной;
				НовРис.ЦветФона = Новый Цвет(255, 255, 205);
				Если ТекТаблДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет Тогда
					НовРис.Ширина = ШиринаРисунка;
					НовРис.Высота = ВысотаРисунка;
				Иначе
					НовРис.Ширина = ВысотаРисунка;
					НовРис.Высота = ШиринаРисунка;
				КонецЕсли;
				НовРис.Лево = Отступ + ((Инд % РисунковВСтроке) * (ШиринаРисунка + Интервал)) + Цел((ШиринаРисунка + Интервал - НовРис.Ширина) / 2);
				НовРис.Верх = Отступ + ((Цел(Инд / РисунковВСтроке)) * (ВысотаРисунка + Интервал)) + Цел((ВысотаРисунка + Интервал - НовРис.Высота) / 2);
				
				КоличествоЛистовВсего = ТекТаблДок.КоличествоСтраниц();
				ТекстЛистовВсего = Формат(КоличествоЛистовВсего, "ЧГ=")
				+ " "
				+ СтрЗаменить(ЧислоПрописью(КоличествоЛистовВсего, "НП=Истина, НД=Ложь", "лист, листа, листов, м, , , , ,0"),
				ЧислоПрописью(КоличествоЛистовВсего, "НП=Ложь, НД=Ложь", " , , , , , , , ,0"),
				"");
				НовРис.Текст = ТекСтр.Объект + Символы.ПС + "(" + ТекстЛистовВсего + ")";
				
				НовРис.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
				НовРис.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
				НовРис.Имя = "Лист" + Формат(Инд, "ЧН=0; ЧГ=");
				
				Если СоответствиеЛистовСписку.Свойство(НовРис.Имя) Тогда 
					СоответствиеЛистовСписку.Удалить(НовРис.Имя);
				КонецЕсли;
				СоответствиеЛистовСписку.Вставить(НовРис.Имя, ТекСтр.ПолучитьИдентификатор());
				НовРис.Защита = Истина;
				
			КонецЦикла;
			
		Иначе
			
			Элементы.ИтоговаяТаблица.ТолькоПросмотр = Истина;
			ТД = Новый ТабличныйДокумент;
			
			КолСтрокВГруппе = СписокОбъектовДляПечати.Количество();
			Отступ			= 10;
			Интервал		= 16;
			ШиринаРисунка	= 24;
			ВысотаРисунка	= 30;
			РисунковВСтроке	= 4;
			ТД.Область().ЦветФона = Новый Цвет(255, 251, 240);
			
			Для Инд = 0 По КолСтрокВГруппе - 1 Цикл
				
				ТекСтр = СписокОбъектовДляПечати[Инд];
				
				ТекТаблДок = ПолучитьИзВременногоХранилища(ТекСтр.ТабличныйДокумент);
				
				НовРис = ТД.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Текст);
				НовРис.Узор = ТипУзораТабличногоДокумента.Сплошной;
				НовРис.ЦветФона = Новый Цвет(255, 255, 205);
				Если ТекТаблДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет Тогда
					НовРис.Ширина = ШиринаРисунка;
					НовРис.Высота = ВысотаРисунка;
				Иначе
					НовРис.Ширина = ВысотаРисунка;
					НовРис.Высота = ШиринаРисунка;
				КонецЕсли;
				НовРис.Лево = Отступ + ((Инд % РисунковВСтроке) * (ШиринаРисунка + Интервал)) + Цел((ШиринаРисунка + Интервал - НовРис.Ширина) / 2);
				НовРис.Верх = Отступ + ((Цел(Инд / РисунковВСтроке)) * (ВысотаРисунка + Интервал)) + Цел((ВысотаРисунка + Интервал - НовРис.Высота) / 2);
				НовРис.ГиперСсылка = Истина;
				
				КоличествоЛистовВсего = ТекТаблДок.КоличествоСтраниц();
				ТекстЛистовВсего = Формат(КоличествоЛистовВсего, "ЧГ=")
				+ " "
				+ СтрЗаменить(ЧислоПрописью(КоличествоЛистовВсего, "НП=Истина, НД=Ложь", "лист, листа, листов, м, , , , ,0"),
				ЧислоПрописью(КоличествоЛистовВсего, "НП=Ложь, НД=Ложь", " , , , , , , , ,0"),
				"");
				НовРис.Текст = ТекСтр.Объект + Символы.ПС + "(" + ТекстЛистовВсего + ")";
				
				НовРис.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
				НовРис.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
				НовРис.Имя = "Лист" + Формат(Инд, "ЧН=0; ЧГ=");
				
				Если СоответствиеЛистовСписку.Свойство(НовРис.Имя) Тогда 
					СоответствиеЛистовСписку.Удалить(НовРис.Имя);
				КонецЕсли;
				СоответствиеЛистовСписку.Вставить(НовРис.Имя, ТекСтр.ПолучитьИдентификатор());
				НовРис.Защита = Истина;
				
				НовЛиния = ТД.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
				НовЛиния.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
				НовЛиния.ГиперСсылка = Истина;
				
				Если ТекТаблДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет Тогда
					НовЛиния.Ширина = ШиринаРисунка - 0.3;
					НовЛиния.Высота = 0.01;
				Иначе
					НовЛиния.Ширина = ВысотаРисунка - 0.3;
					НовЛиния.Высота = 0.01;
				КонецЕсли;
				НовЛиния.Лево = НовРис.Лево + 0.3;
				НовЛиния.Верх = НовРис.Верх + НовРис.Высота;
				НовЛиния.Имя = "ЛНПН" + Формат(Инд, "ЧН=0; ЧГ=");
				
				НовЛиния = ТД.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
				НовЛиния.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
				НовЛиния.ГиперСсылка = Истина;
				Если ТекТаблДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет Тогда
					НовЛиния.Ширина = 0.01;
					НовЛиния.Высота = ВысотаРисунка - 0.3;
				Иначе
					НовЛиния.Ширина = 0.01;
					НовЛиния.Высота = ШиринаРисунка - 0.3;
				КонецЕсли;
				НовЛиния.Лево = НовРис.Лево + НовРис.Ширина;
				НовЛиния.Верх = НовРис.Верх + 0.3;
				НовЛиния.Имя = "ПНПВ" + Формат(Инд, "ЧН=0; ЧГ=");
				
				
			КонецЦикла;
			
		КонецЕсли;
		
		ИтоговаяТаблица = ТД;
		Элементы.ИтоговаяТаблица.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивОписанийФайловВыгрузки(ВФормате)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	СоответствиеФорматаРасширению = Новый Соответствие;
	СоответствиеФорматаРасширению.Вставить(ТипФайлаТабличногоДокумента.MXL, "mxl");
	СоответствиеФорматаРасширению.Вставить(ТипФайлаТабличногоДокумента.XLS, "xls");
	
	МассивОписаний = Новый Массив;
	
	Для Каждого Эл Из СписокОбъектовДляПечати Цикл
		Если Эл.Пометка Тогда
			ИмяОбъктаБезДвоеточий = КонтекстЭДОСервер.СформироватьИмяФайла(Строка(Эл.Объект));
			КороткоеИмяФайла = ИмяОбъктаБезДвоеточий + "." + СоответствиеФорматаРасширению[ВФормате];

			ФайлТабличногоДокумента = ПолучитьИмяВременногоФайла();
			ТабличныйДокумент = ПолучитьИзВременногоХранилища(Эл.ТабличныйДокумент);
			ТабличныйДокумент.Записать(ФайлТабличногоДокумента, ВФормате); //ТипФайлаТабличногоДокумента.XLS);
			ГУИД = Новый УникальныйИдентификатор;
			ДанныеФайла = Новый ДвоичныеДанные(ФайлТабличногоДокумента);
			
			Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла, ГУИД);
			
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(КороткоеИмяФайла, Адрес); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьНаДиск(ВФормате)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьНаДискЗавершение", ЭтотОбъект, ВФормате);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Функция КоличествоВыбранныхТабличныхДокументов()
	
	Кол = 0;
	Для Каждого Стр Из СписокОбъектовДляПечати Цикл
		Кол = Кол + ?(Стр.Пометка, 1, 0);
	КонецЦикла;
	Возврат Кол;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТранспортноеСообщениеСУказаннымВложением(ЦиклОбмена, ИмяВложения)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение
		|ИЗ
		|	РегистрСведений.СодержимоеТранспортныхКонтейнеров КАК СодержимоеТранспортныхКонтейнеров
		|ГДЕ
		|	СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение.ЦиклОбмена = &ЦиклОбмена
		|	И СодержимоеТранспортныхКонтейнеров.ИмяФайла = &ИмяФайла";

	Запрос.УстановитьПараметр("ИмяФайла", ИмяВложения);
	Запрос.УстановитьПараметр("ЦиклОбмена", ЦиклОбмена);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		 Возврат ВыборкаДетальныеЗаписи.ТранспортноеСообщение;
	КонецЦикла;

КонецФункции

&НаКлиенте
Процедура ВыгрузитьНаДискЗавершение(Результат, ВФормате) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если КоличествоВыбранныхТабличныхДокументов() = 0 Тогда
		ПоказатьПредупреждение(,"Выберите листы в дереве печатаемых листов!");
	Иначе
		МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВыгрузки(ВФормате);
		
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИтоговаяТаблицаОбработкаРасшифровкиЗавершение(Результат, Расшифровка) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТранспортноеСообщение = ТранспортноеСообщениеСУказаннымВложением(ЦиклОбмена, Расшифровка);
	Если ЗначениеЗаполнено(ТранспортноеСообщение) Тогда
		КонтекстЭДОКлиент.ПоказатьПротоколПриложениеПФР(ТранспортноеСообщение, Расшифровка);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
