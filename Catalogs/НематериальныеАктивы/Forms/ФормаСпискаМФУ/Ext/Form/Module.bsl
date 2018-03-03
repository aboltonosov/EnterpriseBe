﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.НематериальныеАктивы);
	Элементы.ИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, "ФормаСписка");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Состояние",
		ОтборСостояние,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборСостояние));
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Состояние",
		ОтборСостояние,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборСостояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьСведения", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Скрыть сведения'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Показать сведения'");
	КонецЕсли;
	
КонецПроцедуры

#Область СтандатрныеПодсистемы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСвойстваЭлементовСведений()
	
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Скрыть сведения'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Показать сведения'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	//++ НЕ УТКА
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаЗаголовок.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Константы.ВалютаФункциональная.Получить());
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаПредставленияЗаголовок.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Константы.ВалютаПредставления.Получить());
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведения()
	
	Если ПоказатьСведения Тогда
		
		СведенияТаблицаСумм.Очистить();
		Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 Тогда
			ДанныеСтроки = Элементы.Список.ТекущиеДанные;
			Массив = ПолучитьСведения(ДанныеСтроки.Ссылка, ДанныеСтроки.СчетУчета, ДанныеСтроки.СчетАмортизации);
			Для Каждого ЭлементМассива Из Массив Цикл
				ЗаполнитьЗначенияСвойств(СведенияТаблицаСумм.Добавить(), ЭлементМассива);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения(ВнеоборотныйАктив, СчетУчета, СчетАмортизации)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("Стоимость", 0);
	ЗначенияПоУмолчанию.Вставить("СтоимостьПредставления", 0);
	ЗначенияПоУмолчанию.Вставить("Амортизация", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияПредставления", 0);
	//++ НЕ УТКА
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(Стоимость.СуммаОстаток, 0) КАК Стоимость,
		|	ЕСТЬNULL(Стоимость.СуммаПредставленияОстаток, 0) КАК СтоимостьПредставления,
		|	-ЕСТЬNULL(Амортизация.СуммаОстаток, 0) КАК Амортизация,
		|	-ЕСТЬNULL(Амортизация.СуммаПредставленияОстаток, 0) КАК АмортизацияПредставления
		|ИЗ
		|	РегистрБухгалтерии.Международный.Остатки(, Счет В (&СчетаУчета), , Субконто1 В (&ВнеоборотныйАктив)) КАК Стоимость
		|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(, Счет В (&СчетаАмортизации), , Субконто1 В (&ВнеоборотныйАктив)) КАК Амортизация
		|		ПО Стоимость.Субконто1 = Амортизация.Субконто1"
	);
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	Запрос.УстановитьПараметр("СчетаУчета", СчетУчета);
	Запрос.УстановитьПараметр("СчетаАмортизации", СчетАмортизации);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЗначенияПоУмолчанию, Выборка);
	КонецЕсли;
	//-- НЕ УТКА
	
	ЗаголовокВалюты = Строка(Константы.ВалютаРегламентированногоУчета.Получить());
	
	Поля = "Представление, Сумма, СуммаПредставления";
	
	Массив = Новый Массив;
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru='Первоначальная стоимость:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Стоимость;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.СтоимостьПредставления;
	Массив.Добавить(Строка);
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru='Накопленная амортизация:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Амортизация;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.АмортизацияПредставления;
	Массив.Добавить(Строка);
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru='Остаточная стоимость:'");
	Строка.Сумма = ЗначенияПоУмолчанию.Стоимость-ЗначенияПоУмолчанию.Амортизация;
	Строка.СуммаПредставления = ЗначенияПоУмолчанию.СтоимостьПредставления-ЗначенияПоУмолчанию.АмортизацияПредставления;
	Массив.Добавить(Строка);
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти