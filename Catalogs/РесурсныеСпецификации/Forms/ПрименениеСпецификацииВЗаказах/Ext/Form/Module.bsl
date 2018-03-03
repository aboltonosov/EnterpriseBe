﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	//++ НЕ УТКА
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиПодсистемыПроизводство = ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	Если НЕ НастройкиПодсистемыПроизводство.ИспользуетсяПроизводство21 
		И НЕ НастройкиПодсистемыПроизводство.ИспользуетсяПроизводство22 Тогда
		ВызватьИсключение НСтр("ru = 'Для открытия формы необходимо включить подсистему управления производством.'");
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиПодсистемыПроизводство);
	
	Если НастройкиПодсистемыПроизводство.ИспользуетсяПроизводство21 
		ИЛИ НастройкиПодсистемыПроизводство.ПланируетсяГрафикПроизводства Тогда
		Элементы.СписокЗаказовСостояниеГрафика.Видимость = Истина;
	Иначе
		Элементы.СписокЗаказовСостояниеГрафика.Видимость = Ложь;
	КонецЕсли;
	
	Спецификация = Параметры.Спецификация;
	
	ЗаполнитьСписокЗаказов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//++ НЕ УТКА
	Если СтрНайти("Запись_ЗаказНаПроизводство, Запись_ЭтапПроизводства2_2, Запись_ГрафикПроизводства", ИмяСобытия) > 0
		И Источник <> "ПрименениеСпецификацииВЗаказах" Тогда
		ЗаполнитьСписокЗаказов();
	КонецЕсли; 
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	//++ НЕ УТКА
	Если ИсточникВыбора.ИмяФормы = "Справочник.РесурсныеСпецификации.Форма.ВыборДействующихСпецификаций" Тогда
		ЗаменитьСпецификациюЗавершение(ВыбранноеЗначение);
	КонецЕсли; 
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗаказов

&НаКлиенте
Процедура СписокЗаказовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокЗаказов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.УправлениеПроизводством22 Тогда
		
		Если ТекущиеДанные.ПроизводитсяВПроцессе Тогда
			ПоказатьЗначение(, ТекущиеДанные.ЭтапПроизводства);
		Иначе
			ПоказатьЗначение(, ТекущиеДанные.Заказ);
		КонецЕсли;
		
	Иначе
		
		ПараметрыФормы = Новый Структура("Ключ,АктивироватьСтрокуПродукции", 
						ТекущиеДанные.Заказ, ТекущиеДанные.КодСтроки);
						
		ОткрытьФорму("Документ.ЗаказНаПроизводство.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаменитьСпецификацию(Команда)
	
	//++ НЕ УТКА
	
	ВыбраныСтрокиПоКоторымПроизводствоНеЗапущено = Ложь;
	ИсключитьИзВыбораСпецификацию = Неопределено;
	
	ДанныеВыбранныхСтрок = Новый Массив;
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		ИдентификаторСтроки = ДанныеСтроки.ПолучитьИдентификатор();
		Если Элементы.СписокЗаказов.ВыделенныеСтроки.Найти(ИдентификаторСтроки) = Неопределено Тогда
			ДанныеСтроки.Заменить = Ложь;
			Продолжить;
		КонецЕсли;
		ДанныеСтроки.Заменить = Истина;
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("Номенклатура",   ДанныеСтроки.Номенклатура);
		СтруктураДанных.Вставить("Характеристика", ДанныеСтроки.Характеристика);
		СтруктураДанных.Вставить("Подразделение",  ДанныеСтроки.Подразделение);
		ДанныеВыбранныхСтрок.Добавить(СтруктураДанных);
		
		Если НЕ ДанныеСтроки.ПроизводствоЗапущено Тогда
			ВыбраныСтрокиПоКоторымПроизводствоНеЗапущено = Истина;
		КонецЕсли;
		
		Если НЕ ДанныеСтроки.ТекущаяСпецификацияБольшеНеИспользуется Тогда
			// выбрана строка для которой используется текущая спецификация
			// поэтому запретим выбор текущей спецификации для замены
			ИсключитьИзВыбораСпецификацию = Спецификация;
		КонецЕсли;
	КонецЦикла;
	
	Если ДанныеВыбранныхСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать строки, в которых требуется выполнить замену.'"));
		Возврат;
		
	ИначеЕсли НЕ ВыбраныСтрокиПоКоторымПроизводствоНеЗапущено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Замена спецификации допускается только для продукции и полуфабрикатов,
											|производство которых не запущено (запланировано).'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокИзделий", ДанныеВыбранныхСтрок);
	ПараметрыФормы.Вставить("ИсключитьИзВыбораСпецификацию", ИсключитьИзВыбораСпецификацию);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Выберите спецификацию, которая будет использоваться для выбранной продукции (полуфабрикатов)'"));
	ОткрытьФорму("Справочник.РесурсныеСпецификации.Форма.ВыборДействующихСпецификаций", ПараметрыФормы, ЭтаФорма);
	
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	//++ НЕ УТКА
	ЗаполнитьСписокЗаказов();
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТКА

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Оформление продукции, для которой уже запущено производство
	#Область ПроизводствоЗапущено
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ПроизводствоЗапущено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(191, 97, 12));
	
	#КонецОбласти
	
	// Оформление продукции, для которой выполнена замена
	#Область ТекущаяСпецификацияБольшеНеИспользуется
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.ТекущаяСпецификацияБольшеНеИспользуется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.НейтральноСерый);
	
	#КонецОбласти
	
	// Стандартное оформление номенклатуры
	#Область Номенклатура

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "СписокЗаказовНоменклатураЕдиницаИзмерения", 
                                                                   "СписокЗаказов.Упаковка");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "СписокЗаказовХарактеристика",
																		     "СписокЗаказов.ХарактеристикиИспользуются");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЗаказовНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокЗаказов.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без назначения>'"));
	
	#КонецОбласти
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗаказов()

	СписокЗаказов.Очистить();

	НаборИсточников = Новый Массив;
	
	Если ИспользуетсяПроизводство21 Тогда
		
		НаборИсточников.Добавить(
			"ВЫБРАТЬ
			|		ТаблицаПродукция.Ссылка КАК Заказ,
			|		ТаблицаПродукция.Ссылка.Номер КАК Номер,
			|		ТаблицаПродукция.Ссылка.Дата КАК Дата,
			|		ТаблицаПродукция.Ссылка.Статус КАК Статус,
			|	
			|		ВЫБОР
			|			КОГДА ТаблицаПродукция.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Создан)
			|				ТОГДА """"
			|			КОГДА ТаблицаПродукция.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.КПроизводству)
			|				ТОГДА ВЫБОР
			|						КОГДА ТаблицаПродукция.Ссылка.СтатусГрафикаПроизводства = ЗНАЧЕНИЕ(Перечисление.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.Рассчитан)
			|							ТОГДА &СостояниеГрафикаВРаботе
			|						КОГДА ТаблицаПродукция.Ссылка.СтатусГрафикаПроизводства = ЗНАЧЕНИЕ(Перечисление.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать)
			|							ТОГДА &СостояниеГрафикаПостроение
			|					КОНЕЦ
			|		КОНЕЦ КАК СостояниеГрафика,
			|		ТаблицаПродукция.НачатьНеРанее КАК НачалоПроизводства,
			|		ТаблицаПродукция.ДатаПотребности КАК ОкончаниеПроизводства,
			|	
			|		ТаблицаПродукция.Ссылка.Подразделение КАК Подразделение,
			|	
			|		ТаблицаПродукция.НомерСтроки КАК НомерСтроки,
			|		ТаблицаПродукция.КодСтроки КАК КодСтроки,
			|		ТаблицаПродукция.КлючСвязи КАК КлючСвязи,
			|		&ПустойКлючСвязи КАК КлючСвязиПродукция,
			|	
			|		ЛОЖЬ КАК ПроизводитсяВПроцессе,
			|		НЕОПРЕДЕЛЕНО КАК ЭтапПроизводства,
			|		"""" КАК ПредставлениеЭтапа,
			|	
			|		ТаблицаПродукция.Назначение КАК Назначение,
			|		ТаблицаПродукция.Номенклатура КАК Номенклатура,
			|		ТаблицаПродукция.Характеристика КАК Характеристика,
			|		ТаблицаПродукция.КоличествоУпаковок КАК Количество,
			|	
			|		ЛОЖЬ КАК УправлениеПроизводством22
			|	ИЗ
			|		Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
			|	ГДЕ
			|		ТаблицаПродукция.Спецификация = &Спецификация
			|		И ТаблицаПродукция.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
			|		И НЕ ТаблицаПродукция.Ссылка.ПометкаУдаления
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ТаблицаМатериалыИУслуги.Ссылка,
			|		ТаблицаМатериалыИУслуги.Ссылка.Номер,
			|		ТаблицаМатериалыИУслуги.Ссылка.Дата,
			|		ТаблицаМатериалыИУслуги.Ссылка.Статус,
			|	
			|		ВЫБОР
			|			КОГДА ТаблицаМатериалыИУслуги.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Создан)
			|				ТОГДА """"
			|			КОГДА ТаблицаМатериалыИУслуги.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.КПроизводству)
			|				ТОГДА ВЫБОР
			|						КОГДА ТаблицаМатериалыИУслуги.Ссылка.СтатусГрафикаПроизводства = ЗНАЧЕНИЕ(Перечисление.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.Рассчитан)
			|							ТОГДА &СостояниеГрафикаВРаботе
			|						КОГДА ТаблицаМатериалыИУслуги.Ссылка.СтатусГрафикаПроизводства = ЗНАЧЕНИЕ(Перечисление.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать)
			|							ТОГДА &СостояниеГрафикаПостроение
			|					КОНЕЦ
			|		КОНЕЦ,
			|		ТаблицаПродукция.НачатьНеРанее,
			|		ТаблицаПродукция.ДатаПотребности,
			|	
			|		ТаблицаМатериалыИУслуги.Ссылка.Подразделение,
			|	
			|		ТаблицаПродукция.НомерСтроки,
			|		ТаблицаПродукция.КодСтроки,
			|		ТаблицаМатериалыИУслуги.КлючСвязи,
			|		ТаблицаМатериалыИУслуги.КлючСвязиПродукция,
			|	
			|		ИСТИНА КАК ПроизводитсяВПроцессе,
			|		НЕОПРЕДЕЛЕНО КАК ЭтапПроизводства,
			|		"""" КАК ПредставлениеЭтапа,
			|	
			|		ТаблицаПродукция.Назначение,
			|		ТаблицаМатериалыИУслуги.Номенклатура,
			|		ТаблицаМатериалыИУслуги.Характеристика,
			|		ТаблицаМатериалыИУслуги.КоличествоУпаковок,
			|	
			|		ЛОЖЬ КАК УправлениеПроизводством22
			|	ИЗ
			|		Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ТаблицаМатериалыИУслуги
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Продукция КАК ТаблицаПродукция
			|			ПО (ТаблицаПродукция.КлючСвязи = ТаблицаМатериалыИУслуги.КлючСвязиПродукция)
			|				И (ТаблицаПродукция.Ссылка = ТаблицаМатериалыИУслуги.Ссылка)
			|	ГДЕ
			|		ТаблицаМатериалыИУслуги.ИсточникПолученияПолуфабриката = &Спецификация
			|		И ТаблицаМатериалыИУслуги.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство.Закрыт)
			|		И НЕ ТаблицаМатериалыИУслуги.Ссылка.ПометкаУдаления");
		
	КонецЕсли;
	
	Если ИспользуетсяПроизводство22 Тогда
		
		НаборИсточников.Добавить(
			"ВЫБРАТЬ
			|		Таблица.Ссылка                   КАК Заказ,
			|		Таблица.Ссылка.Номер             КАК Номер,
			|		Таблица.Ссылка.Дата              КАК Дата,
			|		Таблица.Ссылка.Статус            КАК Статус,
			|
			|		ВЫБОР
			|			КОГДА Таблица.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.Формируется)
			|				ТОГДА """"
			|			КОГДА Таблица.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.КПроизводству)
			|				ТОГДА ВЫБОР
			|						КОГДА ИСТИНА В
			|								(ВЫБРАТЬ ПЕРВЫЕ 1
			|									ИСТИНА
			|								ИЗ
			|									РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК Т
			|								ГДЕ
			|									Т.Распоряжение = Таблица.Ссылка)
			|							И НЕ ИСТИНА В
			|								(ВЫБРАТЬ ПЕРВЫЕ 1
			|									ИСТИНА
			|								ИЗ
			|									РегистрСведений.ЗаданияКРасчетуГрафикаПроизводства КАК Т
			|								ГДЕ
			|									Т.Распоряжение = Таблица.Ссылка)
			|							ТОГДА &СостояниеГрафикаВРаботе
			|						ИНАЧЕ &СостояниеГрафикаПостроение
			|					КОНЕЦ
			|		КОНЕЦ                            КАК СостояниеГрафика,
			|		Таблица.Ссылка.НачатьНеРанее     КАК НачалоПроизводства,
			|		Таблица.Ссылка.ДатаПотребности   КАК ОкончаниеПроизводства,
			|
			|		Таблица.Ссылка.Подразделение     КАК Подразделение,
			|
			|		Таблица.НомерСтроки              КАК НомерСтроки,
			|		Таблица.НомерСтроки              КАК КодСтроки,
			|		&ПустойКлючСвязи                 КАК КлючСвязи,
			|		&ПустойКлючСвязи                 КАК КлючСвязиПродукция,
			|
			|		ЛОЖЬ КАК ПроизводитсяВПроцессе,
			|		НЕОПРЕДЕЛЕНО КАК ЭтапПроизводства,
			|		"""" КАК ПредставлениеЭтапа,
			|
			|		Таблица.Назначение               КАК Назначение,
			|		Таблица.Номенклатура             КАК Номенклатура,
			|		Таблица.Характеристика           КАК Характеристика,
			|		Таблица.КоличествоУпаковок       КАК Количество,
			|
			|		ИСТИНА КАК УправлениеПроизводством22
			|		
			|	ИЗ
			|		Документ.ЗаказНаПроизводство2_2.Продукция КАК Таблица
			|	ГДЕ
			|		Таблица.Спецификация = &Спецификация
			|		И Таблица.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.Закрыт)
			|		И НЕ Таблица.Ссылка.ПометкаУдаления");
		
		НаборИсточников.Добавить(
			"ВЫБРАТЬ
			|		Таблица.Ссылка.Распоряжение        КАК Заказ,
			|		Таблица.Ссылка.Распоряжение.Номер  КАК Номер,
			|		Таблица.Ссылка.Распоряжение.Дата   КАК Дата,
			|		Таблица.Ссылка.Распоряжение.Статус КАК Статус,
			|
			|		ВЫБОР
			|			КОГДА Таблица.Ссылка.Распоряжение.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.Формируется)
			|				ТОГДА """"
			|			КОГДА Таблица.Ссылка.Распоряжение.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.КПроизводству)
			|				ТОГДА ВЫБОР
			|						КОГДА ИСТИНА В
			|								(ВЫБРАТЬ ПЕРВЫЕ 1
			|									ИСТИНА
			|								ИЗ
			|									РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК Т
			|								ГДЕ
			|									Т.Распоряжение = Таблица.Ссылка.Распоряжение)
			|							И НЕ ИСТИНА В
			|								(ВЫБРАТЬ ПЕРВЫЕ 1
			|									ИСТИНА
			|								ИЗ
			|									РегистрСведений.ЗаданияКРасчетуГрафикаПроизводства КАК Т
			|								ГДЕ
			|									Т.Распоряжение = Таблица.Ссылка.Распоряжение)
			|							ТОГДА &СостояниеГрафикаВРаботе
			|						ИНАЧЕ &СостояниеГрафикаПостроение
			|					КОНЕЦ
			|		КОНЕЦ                                       КАК СостояниеГрафика,
			|		Таблица.Ссылка.Распоряжение.НачатьНеРанее   КАК НачалоПроизводства,
			|		Таблица.Ссылка.Распоряжение.ДатаПотребности КАК ОкончаниеПроизводства,
			|
			|		Таблица.Ссылка.Распоряжение.Подразделение КАК Подразделение,
			|
			|		Таблица.НомерСтроки КАК НомерСтроки,
			|		Таблица.НомерСтроки КАК КодСтроки,
			|		&ПустойКлючСвязи    КАК КлючСвязи,
			|		&ПустойКлючСвязи    КАК КлючСвязиПродукция,
			|
			|		ИСТИНА              КАК ПроизводитсяВПроцессе,
			|		Таблица.Ссылка      КАК ЭтапПроизводства,
			|		&ПредставлениеЭтапа КАК ПредставлениеЭтапа,
			|
			|		ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
			|		Таблица.Номенклатура                         КАК Номенклатура,
			|		Таблица.Характеристика                       КАК Характеристика,
			|		Таблица.КоличествоУпаковок                   КАК Количество,
			|
			|		ИСТИНА КАК УправлениеПроизводством22
			|		
			|	ИЗ
			|		Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК Таблица
			|	ГДЕ
			|		Таблица.Спецификация = &Спецификация
			|		И Таблица.Производится
			|		И Таблица.Ссылка.Распоряжение.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовНаПроизводство2_2.Закрыт)
			|		И НЕ Таблица.Ссылка.ПометкаУдаления");
	КонецЕсли;
	
	ТекстСписокЗаказов = СтрСоединить(НаборИсточников, " ОБЪЕДИНИТЬ ВСЕ ");
	ТекстСписокЗаказов = СтрЗаменить(
		ТекстСписокЗаказов,
		"&ПредставлениеЭтапа",
		Документы.ЭтапПроизводства2_2.ТекстЗапросаПредставлениеЭтапа("Таблица.Ссылка"));
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СписокЗаказов.Заказ                 КАК Заказ,
		|	СписокЗаказов.Номер                 КАК Номер,
		|	СписокЗаказов.Дата                  КАК Дата,
		|	СписокЗаказов.Статус                КАК Статус,
		|
		|	СписокЗаказов.СостояниеГрафика      КАК СостояниеГрафика,
		|	СписокЗаказов.НачалоПроизводства    КАК НачалоПроизводства,
		|	СписокЗаказов.ОкончаниеПроизводства КАК ОкончаниеПроизводства,
		|
		|	СписокЗаказов.Подразделение         КАК Подразделение,
		|
		|	СписокЗаказов.НомерСтроки           КАК НомерСтроки,
		|	СписокЗаказов.КодСтроки             КАК КодСтроки,
		|	СписокЗаказов.КлючСвязи             КАК КлючСвязи,
		|	СписокЗаказов.КлючСвязиПродукция    КАК КлючСвязиПродукция,
		|
		|	СписокЗаказов.ПроизводитсяВПроцессе КАК ПроизводитсяВПроцессе,
		|	СписокЗаказов.ЭтапПроизводства      КАК ЭтапПроизводства,
		|	СписокЗаказов.ПредставлениеЭтапа    КАК ПредставлениеЭтапа,
		|
		|	СписокЗаказов.Назначение            КАК Назначение,
		|	СписокЗаказов.Номенклатура          КАК Номенклатура,
		|	СписокЗаказов.Характеристика        КАК Характеристика,
		|	ВЫБОР
		|		КОГДА СписокЗаказов.Номенклатура.ИспользованиеХарактеристик В (
		|				ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), 
		|				ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), 
		|				ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ                               КАК ХарактеристикиИспользуются,
		|	СписокЗаказов.Количество            КАК Количество,
		|
		|	СписокЗаказов.УправлениеПроизводством22
		|
		|ИЗ
		|	(" + ТекстСписокЗаказов + ") КАК СписокЗаказов
		|
		|УПОРЯДОЧИТЬ ПО
		|	НачалоПроизводства, Заказ, ПроизводитсяВПроцессе УБЫВ");
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("ПустойКлючСвязи", ПустойКлючСвязи);
	
	Запрос.УстановитьПараметр("СостояниеГрафикаВРаботе", НСтр("ru = 'В работе'"));
	Запрос.УстановитьПараметр("СостояниеГрафикаПостроение", НСтр("ru = 'Построение'"));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = СписокЗаказов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НомерЗаказа = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер);
		Если Выборка.ПроизводитсяВПроцессе И Выборка.УправлениеПроизводством22 Тогда
			
			ПредставлениеЗаказа = СтрШаблон(НСтр("ru = '№%1 от %2 (%3, строка %4)'"), 
											НомерЗаказа, 
											Формат(Выборка.Дата, "ДЛФ=D"),
											Выборка.ПредставлениеЭтапа,
											Формат(Выборка.НомерСтроки, "ЧГ="));
											
		Иначе
			
			ПредставлениеЗаказа = СтрШаблон(НСтр("ru = '№%1 от %2 (строка %3)'"), 
											НомерЗаказа, 
											Формат(Выборка.Дата, "ДЛФ=D"),	
											Формат(Выборка.НомерСтроки, "ЧГ="));
											
		КонецЕсли;
		НоваяСтрока.ПредставлениеЗаказа = ПредставлениеЗаказа;
		
	КонецЦикла;
	
	ОпределитьПроизводствоЗапущено();
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьПроизводствоЗапущено()
	
	Если ИспользуетсяПроизводство21 Тогда
		
		Отбор = Новый Структура("УправлениеПроизводством22", Ложь);
		
		ТаблицаСписокЗаказов = СписокЗаказов.Выгрузить(Отбор, "Заказ,КодСтроки");
		ТаблицаСписокЗаказов.Свернуть("Заказ,КодСтроки");
		
		Заказы21Запущены = ПланированиеПроизводства.ЭтапыПоКоторымЗапущеноПроизводство(ТаблицаСписокЗаказов);
		
	КонецЕсли;
	
	Если ИспользуетсяПроизводство22 Тогда
		
		Отбор = Новый Структура("УправлениеПроизводством22", Истина);
		
		ТаблицаСписокЗаказов = СписокЗаказов.Выгрузить(Отбор, "Заказ");
		ТаблицаСписокЗаказов.Свернуть("Заказ");
		
		Распоряжения = ТаблицаСписокЗаказов.ВыгрузитьКолонку(0);
		Заказы22Запущены = РегистрыНакопления.ПродукцияИПолуфабрикатыВПроизводстве.ЗаказыЗапланированы(Распоряжения);
		
	КонецЕсли;
	
	Для каждого ДанныеСтроки Из СписокЗаказов Цикл
		
		Если ДанныеСтроки.УправлениеПроизводством22 Тогда
			ПроизводствоЗапущено = (Заказы22Запущены[ДанныеСтроки.Заказ] = Истина);
		Иначе
			СтруктураПоиска = Новый Структура("Распоряжение,КодСтрокиПродукция", ДанныеСтроки.Заказ, ДанныеСтроки.КодСтроки);
			ПроизводствоЗапущено = (Заказы21Запущены.НайтиСтроки(СтруктураПоиска).Количество() <> 0);
		КонецЕсли;
		ДанныеСтроки.ПроизводствоЗапущено = ПроизводствоЗапущено;
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьСпецификациюЗавершение(НоваяСпецификация)

	ВыполнитьЗаменуВЗаказахНаСервере(НоваяСпецификация);
	
	ОповеститьОбИзменениях = Ложь;
	
	Если ВсегоЗамен = 0 Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать строки, в которых требуется выполнить замену.'"));
		Возврат;
		
	ИначеЕсли ВыполненоЗамен = ВсегоЗамен Тогда
		
		// Успешно заменили во всех заказах
		ТекстЗавершеннойОперации = НСтр("ru = 'Выполнена замена во всех выбранных строках'");
		ТекстПоясненияЗавершеннойОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														НСтр("ru = 'Изменено строк заказов: %1 из %2'"),
														Формат(ВыполненоЗамен, "ЧГ=0"),
														Формат(ВсегоЗамен, "ЧГ=0"));
														
		ПоказатьОповещениеПользователя(ТекстЗавершеннойОперации,, ТекстПоясненияЗавершеннойОперации);
		
		ОповеститьОбИзменениях = Истина;
		
	ИначеЕсли ВыполненоЗамен = 0 Тогда
		
		// Ни в одном заказе не смогли заменить
		ПоказатьПредупреждение(,НСтр("ru = 'Не удалось выполнить замену.'"));
		Возврат;
		
	Иначе
		
		// В некоторых заказах не смогли заменить
		ТекстЗавершеннойОперации = НСтр("ru = 'Замена выполнена не во всех выбранных строках'");
		ТекстПоясненияЗавершеннойОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														НСтр("ru = 'Изменено строк заказов: %1 из %2'"),
														Формат(ВыполненоЗамен, "ЧГ=0"),
														Формат(ВсегоЗамен, "ЧГ=0"));
														
		ПоказатьОповещениеПользователя(ТекстЗавершеннойОперации,, ТекстПоясненияЗавершеннойОперации);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Замена выполнена не во всех строках заказов (в %1 из %2).'"), 
										Формат(ВыполненоЗамен, "ЧГ=0"), 
										Формат(ВсегоЗамен, "ЧГ=0"));
										
		ПоказатьПредупреждение(, ТекстСообщения);
		
		ОповеститьОбИзменениях = Истина;
		
	КонецЕсли; 
	
	Если ОповеститьОбИзменениях Тогда
		
		Оповестить("Запись_ЗаказНаПроизводство",, "ПрименениеСпецификацииВЗаказах");
		
		Если ИспользуетсяПроизводство21 Тогда
			ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаказНаПроизводство"));
		КонецЕсли;
		
		Если ИспользуетсяПроизводство22 Тогда
			ОповеститьОбИзменении(Тип("ДокументСсылка.ЗаказНаПроизводство2_2"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗаменуВЗаказахНаСервере(Знач НоваяСпецификация)

	// Определим для каких изделий подходит данная спецификация
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РесурсныеСпецификацииВыходныеИзделия.Номенклатура,
		|	РесурсныеСпецификацииВыходныеИзделия.Характеристика
		|ИЗ
		|	Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК РесурсныеСпецификацииВыходныеИзделия
		|ГДЕ
		|	РесурсныеСпецификацииВыходныеИзделия.Ссылка = &Спецификация");
	
	Запрос.УстановитьПараметр("Спецификация", НоваяСпецификация);
	
	ИзделияДляКоторыхПодходитСпецификация = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокХарактеристик = ИзделияДляКоторыхПодходитСпецификация.Получить(Выборка.Номенклатура);
		Если СписокХарактеристик = Неопределено Тогда
			СписокХарактеристик = Новый Массив;
		КонецЕсли;
		СписокХарактеристик.Добавить(Выборка.Характеристика);
		ИзделияДляКоторыхПодходитСпецификация.Вставить(Выборка.Номенклатура, СписокХарактеристик)
	КонецЦикла;
	
	СтруктураПоиска = Новый Структура("Заменить,ПроизводствоЗапущено", Истина, Ложь);
	ТаблицаЗаказы = СписокЗаказов.Выгрузить(СтруктураПоиска);
	ТаблицаЗаказы.Свернуть("Заказ");
	
	ВсегоЗамен = 0;
	ВыполненоЗамен = 0;
	
	Для каждого СтрокаЗаказ Из ТаблицаЗаказы Цикл
		
		ВыполненоЗаменВЗаказе = 0;
		
		// Получим данные замены в заказе
		СтруктураПоиска = Новый Структура("Заказ,Заменить,ПроизводствоЗапущено", СтрокаЗаказ.Заказ, Истина, Ложь);
		СписокСтрок = СписокЗаказов.НайтиСтроки(СтруктураПоиска);
		ДанныеЗамены21 = Новый Массив;
		ДанныеЗамены22 = Новый Массив;
		СтрокиВКоторыхВыполняетсяЗамена21 = Новый Массив;
		СтрокиВКоторыхВыполняетсяЗамена22 = Новый Массив;
		Для каждого ДанныеСтроки Из СписокСтрок Цикл
			ВсегоЗамен = ВсегоЗамен + 1;
			
			// Нужно убедиться, что спецификация подходит для указанной характеристики
			СписокХарактеристик = ИзделияДляКоторыхПодходитСпецификация.Получить(ДанныеСтроки.Номенклатура);
			Если СписокХарактеристик <> Неопределено 
				И (СписокХарактеристик.Найти(ДанныеСтроки.Характеристика) <> Неопределено
					ИЛИ СписокХарактеристик.Найти(Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка()) <> Неопределено) Тогда
				
				Если ДанныеСтроки.УправлениеПроизводством22 Тогда
					
					СтруктураЗамены = УправлениеПроизводствомКлиентСервер.СтруктураЗаменыСпецификации();
					
					СтруктураЗамены.Заказ = ДанныеСтроки.Заказ;
					СтруктураЗамены.НомерСтроки = ДанныеСтроки.КодСтроки;
					
					Если НЕ ДанныеСтроки.ТекущаяСпецификацияБольшеНеИспользуется Тогда
						СтруктураЗамены.Спецификация = Спецификация;
					КонецЕсли;
					СтруктураЗамены.НоваяСпецификация = НоваяСпецификация;
					
					ДанныеЗамены22.Добавить(СтруктураЗамены);
					СтрокиВКоторыхВыполняетсяЗамена22.Добавить(ДанныеСтроки);
					
				Иначе
					
					ПараметрыЗамены = Новый Структура;
					ПараметрыЗамены.Вставить("КлючСвязи", ДанныеСтроки.КлючСвязи);
					ПараметрыЗамены.Вставить("КлючСвязиПродукция", ДанныеСтроки.КлючСвязиПродукция);
					ПараметрыЗамены.Вставить("Спецификация", НоваяСпецификация);
					
					ДанныеЗамены21.Добавить(ПараметрыЗамены);
					СтрокиВКоторыхВыполняетсяЗамена21.Добавить(ДанныеСтроки);
					
				КонецЕсли;
				ВыполненоЗаменВЗаказе = ВыполненоЗаменВЗаказе + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ДанныеЗамены21.Количество() <> 0 Тогда
			
			ЗаказОбъект = ДанныеСтроки.Заказ.ПолучитьОбъект();
			ЗаказОбъект.ЗаменитьСпецификации(ДанныеЗамены21);
			
			Если ЗаказОбъект.ПроверитьЗаполнение() Тогда
				Попытка
					
					Если ЗаказОбъект.Проведен Тогда
						ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
					Иначе	
						ЗаказОбъект.Записать(РежимЗаписиДокумента.Запись);
					КонецЕсли;
					ВыполненоЗамен = ВыполненоЗамен + ВыполненоЗаменВЗаказе;
					
					Для каждого ДанныеСтроки Из СтрокиВКоторыхВыполняетсяЗамена21 Цикл
						ДанныеСтроки.ТекущаяСпецификацияБольшеНеИспользуется = (НоваяСпецификация <> Спецификация);
					КонецЦикла;
				Исключение
				КонецПопытки;
				
			КонецЕсли; 
			
		КонецЕсли; 
		
		Если ДанныеЗамены22.Количество() <> 0 Тогда
			
			РезультатЗамены = Документы.ЗаказНаПроизводство2_2.ЗаменитьСпецификации(ДанныеЗамены22);
			Если Не РезультатЗамены.ЕстьОшибки Тогда
				Для каждого ДанныеСтроки Из СтрокиВКоторыхВыполняетсяЗамена22 Цикл
					ДанныеСтроки.ТекущаяСпецификацияБольшеНеИспользуется = (НоваяСпецификация <> Спецификация);
				КонецЦикла;
				ВыполненоЗамен = ВыполненоЗамен + РезультатЗамены.ВыполненоЗамен;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

//-- НЕ УТКА