﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначенияДляЗаполнения  = Новый Структура("Организация", "Организация");	
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = ЗарплатаКадры.ПерваяДоступнаяОрганизация();
	КонецЕсли; 
	
	СохраненныйСотрудник = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РаботаСКадрами", "Сотрудник");
	Если СохраненныйСотрудник = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	Сотрудники.Ссылка
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники
			|
			|УПОРЯДОЧИТЬ ПО
			|	Сотрудники.Наименование";
			
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сотрудник = Выборка.Ссылка;
		КонецЕсли; 
	Иначе
		Сотрудник = СохраненныйСотрудник;
	КонецЕсли; 
	
	УстановитьОтборЖурналовПоОрганизации();
	
	ПрочитатьДанныеСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" 
		И (Источник = ФизическоеЛицо ИЛИ Источник = Сотрудник) Тогда
		
		ПрочитатьДанныеСотрудника();
		
	ИначеЕсли ИмяСобытия = "ИзменениеДанныхМестаРаботы" 
		ИЛИ ИмяСобытия = "ДокументДоговорРаботыУслугиПослеЗаписи"
		ИЛИ ИмяСобытия = "ДокументДоговорАвторскогоЗаказаПослеЗаписи"
		ИЛИ ИмяСобытия = "ДокументНачальнаяШтатнаяРасстановкаПослеЗаписи" Тогда
		
		ОбновитьСписки(ЭтаФорма, Истина, Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ПрочитатьДанныеСотрудника();
	
	ПодключитьОбработчикОжидания("ПриИзмененииСохраняемойНастройки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникАдресЭлектроннойПочтыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформациейКлиент.СоздатьЭлектронноеПисьмо("", ЭлектронныйАдрес);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйСотрудник(Команда)
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСотрудникаВАрхив(Команда)
	
	ОтправитьСотрудникаВАрхивНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПриемНаРаботу(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ПриемНаРаботу");
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорРаботыУслуги(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ДоговорРаботыУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорАвторскогоЗаказа(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ДоговорАвторскогоЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправкаОЗаработке(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьКадровыхПриказовРасширенная", "ПФ_MXL_СправкаОДоходахПроизвольнаяФорма",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправкаСМестаРаботы(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьКадровыхПриказовРасширенная", "ПФ_MXL_СправкаСМестаРаботы",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправка2НДФЛ(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ = Справки2НДФЛ(Сотрудник);
	
	СписокСправок = ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.Справки2НДФЛ;
	
	ДополнительныеПараметры = Новый Структура("ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ);
	
	Если СписокСправок.Количество() > 0 Тогда
		
		СписокСправок.Добавить(ПредопределенноеЗначение("Документ.СправкаНДФЛ.ПустаяСсылка"), НСтр("ru='Новая справка'"));
		
		Оповещение = Новый ОписаниеОповещения("СотрудникСправка2НДФЛЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВыборИзСписка(Оповещение, СписокСправок, Элементы.СотрудникСправка2НДФЛ);

	Иначе
		СотрудникСправка2НДФЛЗавершение(Новый Структура("Значение", ПредопределенноеЗначение("Документ.СправкаНДФЛ.ПустаяСсылка")), ДополнительныеПараметры);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправка2НДФЛЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СсылкаНаСправку = ВыбранноеЗначение.Значение;
	ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ = ДополнительныеПараметры.ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ;
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ЗначениеЗаполнено(СсылкаНаСправку) Тогда
		ПараметрыОткрытия.Вставить("Ключ", СсылкаНаСправку);
	Иначе
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Сотрудник", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.ФизическоеЛицо);
		ЗначенияЗаполнения.Вставить("Организация", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.Организация);
		
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.СправкаНДФЛ.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Сотрудник, Команда.Имя);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПользователя", "Организация", Организация);
	УстановитьОтборЖурналовПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСохраняемойНастройки()
	
	Настройки = СохраняемыеНастройки();
	Настройки.Сотрудник = Сотрудник;
	
	СохранитьНастройкиНаСервере(Настройки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СохраняемыеНастройки()
	
	Настройки = Новый Структура("Сотрудник");
	Возврат Настройки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(Настройки)
	
	Для Каждого КлючИЗначение Из Настройки Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РаботаСКадрами", КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборЖурналовПоОрганизации()
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(КадровыеПриказыНеПроведенные.Отбор, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(КадровыеПриказыЗавершенные.Отбор, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(СотрудникиБезОтношений.Отбор, "ГоловнаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(СотрудникиСОшибками.Отбор, "ГоловнаяОрганизация");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыНеПроведенные.Отбор, "Организация", Организация);	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыЗавершенные.Отбор, "Организация", Организация);	
	
	ГоловнаяОрганизация = ГоловнаяОрганизация(Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СотрудникиБезОтношений.Отбор, "ГоловнаяОрганизация", ГоловнаяОрганизация);	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СотрудникиСОшибками.Отбор, "ГоловнаяОрганизация", ГоловнаяОрганизация);	
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеСотрудника()
	
	ПредставлениеРабочегоМеста = "";
	СотрудникДатаРождения = "";
	СотрудникАдрес = "";
	СотрудникИНН = "";
	СотрудникСНИЛС = "";
	СотрудникТелефон = "";
	СотрудникДокумент = "";
	СотрудникАдресЭлектроннойПочты = "";
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(КадровыеПриказыСотрудника.Отбор, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(СписочныеДокументыПоСотруднику.Отбор, "Ссылка");
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыСотрудника.Отбор, "Сотрудник", Сотрудник);	
		
		СписочныеДокументыПоСотруднику.ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЖурналДокументовКадровыеДокументы.Ссылка,
			|	ЖурналДокументовКадровыеДокументы.Дата,
			|	ЖурналДокументовКадровыеДокументы.ПометкаУдаления,
			|	ЖурналДокументовКадровыеДокументы.Номер,
			|	ЖурналДокументовКадровыеДокументы.Проведен,
			|	ЖурналДокументовКадровыеДокументы.Организация,
			|	ЖурналДокументовКадровыеДокументы.Сотрудник,
			|	ЖурналДокументовКадровыеДокументы.ДатаСобытия,
			|	ЖурналДокументовКадровыеДокументы.Утвержден,
			|	ЖурналДокументовКадровыеДокументы.Ответственный,
			|	ЖурналДокументовКадровыеДокументы.Комментарий,
			|	ЖурналДокументовКадровыеДокументы.Тип
			|ИЗ
			|	КритерийОтбора.СписочныеДокументыПоСотруднику(&Сотрудник) КАК СписочныеДокументыПоСотруднику
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЖурналДокументов.КадровыеДокументы КАК ЖурналДокументовКадровыеДокументы
			|		ПО СписочныеДокументыПоСотруднику.Ссылка = ЖурналДокументовКадровыеДокументы.Ссылка";
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписочныеДокументыПоСотруднику, "Сотрудник", Сотрудник, Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыСотрудника.Отбор, "Сотрудник", Неопределено);	
		
		СписочныеДокументыПоСотруднику.ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЖурналДокументовКадровыеДокументы.Ссылка,
			|	ЖурналДокументовКадровыеДокументы.Дата,
			|	ЖурналДокументовКадровыеДокументы.ПометкаУдаления,
			|	ЖурналДокументовКадровыеДокументы.Номер,
			|	ЖурналДокументовКадровыеДокументы.Проведен,
			|	ЖурналДокументовКадровыеДокументы.Организация,
			|	ЖурналДокументовКадровыеДокументы.Сотрудник,
			|	ЖурналДокументовКадровыеДокументы.ДатаСобытия,
			|	ЖурналДокументовКадровыеДокументы.Утвержден,
			|	ЖурналДокументовКадровыеДокументы.Ответственный,
			|	ЖурналДокументовКадровыеДокументы.Комментарий,
			|	ЖурналДокументовКадровыеДокументы.Тип
			|ИЗ
			|	ЖурналДокументов.КадровыеДокументы КАК ЖурналДокументовКадровыеДокументы";
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписочныеДокументыПоСотруднику.Отбор, "Ссылка", Неопределено);	
		
	КонецЕсли;
		
	ДатаУвольнения = Неопределено;
	ОформленПоТрудовомуДоговору = Ложь;
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.Адрес);
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыКонтактнойИнформации.Ссылка,
		|	ВидыКонтактнойИнформации.Тип,
		|	ВидыКонтактнойИнформации.РеквизитДопУпорядочивания
		|ПОМЕСТИТЬ ВТВидыКонтактнойИнформации
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Тип В(&МассивТипов)
		|	И ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СправочникФизическиеЛица)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВТВидыКонтактнойИнформации.Ссылка
		|ИЗ
		|	ВТВидыКонтактнойИнформации КАК ВТВидыКонтактнойИнформации
		|ГДЕ
		|	ВТВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТВидыКонтактнойИнформации.Ссылка,
		|	ВТВидыКонтактнойИнформации.РеквизитДопУпорядочивания
		|ИЗ
		|	ВТВидыКонтактнойИнформации КАК ВТВидыКонтактнойИнформации
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТВидыКонтактнойИнформации.Ссылка.РеквизитДопУпорядочивания";
		
	Запрос.УстановитьПараметр("МассивТипов", МассивТипов);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивВидов = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить().ВыгрузитьКолонку("Ссылка");
	ВидимостьПоляЭлектронногоАдреса = НЕ РезультатЗапроса[РезультатЗапроса.Количество() - 2].Пустой();
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		НеобходимыеКадровыеДанные = "ФизическоеЛицо,ДатаРождения,ДатаУвольнения,ОформленПоТрудовомуДоговору,ИНН,СтраховойНомерПФР,ДокументПредставление,ДокументВид,"
			+ "ГоловнаяОрганизация,ТекущаяОрганизация,ТекущееПодразделение,ТекущаяДолжность,ТекущаяДолжностьПоШтатномуРасписанию";
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, НеобходимыеКадровыеДанные, ТекущаяДатаСеанса());
		Если КадровыеДанные.Количество() = 0 Тогда
			Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
		Иначе
			
			ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпциюФормы("ИспользоватьНесколькоОрганизаций");
			
			ДанныеСотрудника = КадровыеДанные[0];
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ТекущаяОрганизация) Тогда
				
				Если ДанныеСотрудника.ОформленПоТрудовомуДоговору Тогда
					
					Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание") Тогда
						ПредставлениеРабочегоМеста = Строка(ДанныеСотрудника.ТекущаяДолжностьПоШтатномуРасписанию);
					Иначе
						ПредставлениеРабочегоМеста = Строка(ДанныеСотрудника.ТекущаяДолжность)
							+ " /" + Строка(ДанныеСотрудника.ТекущееПодразделение) + "/";
					КонецЕсли; 
					
					Если ИспользоватьНесколькоОрганизаций Тогда
						ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " (" + ДанныеСотрудника.ТекущаяОрганизация + ")";
					КонецЕсли; 
				
				Иначе
					
					ПредставлениеРабочегоМеста = НСтр("ru='Договорник'") + " ";
					Если ИспользоватьНесколькоОрганизаций Тогда
						ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " " + ДанныеСотрудника.ТекущаяОрганизация;
					КонецЕсли; 
					
				КонецЕсли;
				
			Иначе
				
				ПредставлениеРабочегоМеста = НСтр("ru='Не оформлен'");
				Если ИспользоватьНесколькоОрганизаций Тогда
					ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " " + НСтр("ru='в'") + " " +  ДанныеСотрудника.ГоловнаяОрганизация;
				КонецЕсли;
				
			КонецЕсли;
			
			ФизическоеЛицо = ДанныеСотрудника.ФизическоеЛицо;
			ДатаУвольнения = ДанныеСотрудника.ДатаУвольнения;
			ОформленПоТрудовомуДоговору = ДанныеСотрудника.ОформленПоТрудовомуДоговору;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ДатаРождения) Тогда
				СотрудникДатаРождения = Формат(ДанныеСотрудника.ДатаРождения, "ДЛФ=DD");
			Иначе
				СотрудникДатаРождения = "<" + НСтр("ru='дата рождения не заполнена'") + ">";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ИНН) Тогда
				СотрудникИНН = ДанныеСотрудника.ИНН;
			Иначе
				СотрудникИНН = "<" + НСтр("ru='ИНН не заполнен'") + ">";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.СтраховойНомерПФР) Тогда
				СотрудникСНИЛС = ДанныеСотрудника.СтраховойНомерПФР;
			Иначе
				СотрудникСНИЛС = "<" + НСтр("ru='СНИЛС не заполнен'") + ">";
			КонецЕсли;

			Если НЕ ПустаяСтрока(ДанныеСотрудника.ДокументПредставление) Тогда
				
				СотрудникДокумент = ДанныеСотрудника.ДокументПредставление;
				
				СотрудникДокумент = СтрЗаменить(СотрудникДокумент, НСтр("ru='серия'"), "") + ":";
				СотрудникДокумент = СтрЗаменить(СотрудникДокумент, ", №", "");
				
				СотрудникДокумент = СокрЛП(СотрудникДокумент);
				
			Иначе
				СотрудникДокумент = "<" + НСтр("ru='документ, удостоверяющий личность не заполнен'") + ">";
			КонецЕсли;
			
			УправлениеКонтактнойИнформацией.СоздатьВТКонтактнаяИнформация(
				Запрос.МенеджерВременныхТаблиц, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
				МассивТипов, МассивВидов);
				
			Запрос.Текст =
				"ВЫБРАТЬ
				|	КонтактнаяИнформация.Тип,
				|	КонтактнаяИнформация.Вид КАК Вид,
				|	КонтактнаяИнформация.Вид.Наименование КАК ВидПредставление,
				|	КонтактнаяИнформация.Представление,
				|	КонтактнаяИнформация.ЗначенияПолей
				|ИЗ
				|	ВТКонтактнаяИнформация КАК КонтактнаяИнформация
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
				|		ПО КонтактнаяИнформация.Вид = ВидыКонтактнойИнформации.Ссылка
				|
				|УПОРЯДОЧИТЬ ПО
				|	ВидыКонтактнойИнформации.РеквизитДопУпорядочивания";
				
			ТаблицаКонтактнойИнформации = Запрос.Выполнить().Выгрузить();
			
			СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				ЭлектронныйАдрес = НайденныеСтроки[0].Представление;

				СотрудникАдресЭлектроннойПочты = ПредставлениеКонтактнойИнформации(
					НайденныеСтроки[0].Представление,
					НайденныеСтроки[0].ВидПредставление,
					Строка(НайденныеСтроки[0].Тип));
					
			Иначе
				ЭлектронныйАдрес = "";
				СотрудникАдресЭлектроннойПочты = "<" + НСтр("ru='адрес электронной почты не заполнен'") + ">";
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"СотрудникАдресЭлектроннойПочты",
				"Гиперссылка",
				НЕ ПустаяСтрока(ЭлектронныйАдрес));
			
			СтруктураПоиска = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СотрудникТелефон = НайденныеСтроки[0].Представление;
			Иначе
				
				СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
				НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
				
					СотрудникТелефон = ПредставлениеКонтактнойИнформации(
						НайденныеСтроки[0].Представление,
						НайденныеСтроки[0].ВидПредставление,
						Строка(НайденныеСтроки[0].Тип));

				Иначе
					СотрудникТелефон = "<" + НСтр("ru='телефон не заполнен'") + ">";
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СотрудникАдрес = НайденныеСтроки[0].Представление;
			Иначе
				
				СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
				НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
				
					СотрудникАдрес = ПредставлениеКонтактнойИнформации(
						НайденныеСтроки[0].Представление,
						НайденныеСтроки[0].ВидПредставление,
						Строка(НайденныеСтроки[0].Тип));

				Иначе
					СотрудникАдрес = "<" + НСтр("ru='адрес не заполнен'") + ">";
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаВсеДанныеСотрудника",
			"Доступность",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОформитьУвольнение",
			"Видимость",
			ОформленПоТрудовомуДоговору И НЕ ЗначениеЗаполнено(ДатаУвольнения));
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СотрудникАдресЭлектроннойПочты",
			"Видимость",
			ВидимостьПоляЭлектронногоАдреса);
			
		ПараметрыПостроения = Новый Структура;
		ПараметрыПостроения.Вставить("Сотрудник", Сотрудник);
		ПараметрыПостроения.Вставить("ОформленПоТрудовомуДоговору", ОформленПоТрудовомуДоговору);
		ПараметрыПостроения.Вставить("ДатаУвольнения", ДатаУвольнения);
		
		СотрудникиФормы.УстановитьМенюВводаНаОсновании(ЭтаФорма, "ОформитьДокумент", ПараметрыПостроения);
		
	Иначе
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаВсеДанныеСотрудника",
			"Доступность",
			Ложь);
			
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтаФорма,
		"Сотрудник",
		ПредставлениеРабочегоМеста);
			
КонецПроцедуры

&НаСервере
Функция ПредставлениеКонтактнойИнформации(Представление, ВидПредставление, ТипПредставление)
	
	Если СтрНайти(ВидПредставление, ТипПредставление) = 1 Тогда
		ПредставлениеВида = СокрЛП(Сред(ВидПредставление, СтрДлина(ТипПредставление) + 1));
	Иначе
		ПредставлениеВида = ВидПредставление;
	КонецЕсли;
	
	Возврат Представление + " (" + ПредставлениеВида + ")";
		
КонецФункции

&НаСервере
Функция ГоловнаяОрганизация(Организация)
	УстановитьПривилегированныйРежим(Истина);
	Возврат РегламентированнаяОтчетность.ГоловнаяОрганизация(Организация);
КонецФункции

&НаСервере
Процедура ОтправитьСотрудникаВАрхивНаСервере()
	
	Если Элементы.СотрудникиБезОтношений.ТекущаяСтрока <> Неопределено Тогда
		
		СотрудникОбъект = Элементы.СотрудникиБезОтношений.ТекущаяСтрока.ПолучитьОбъект();
		
		Попытка 
			СотрудникОбъект.Заблокировать();
		Исключение
			ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось изменить данные сотрудника ""%1"".
			|Возможно, сотрудник редактируется другим пользователем'"),
			СотрудникОбъект.Наименование);			
			ВызватьИсключение ТекстИсключенияЗаписи;
		КонецПопытки;
		
		СотрудникОбъект.ВАрхиве = Истина;
		СотрудникОбъект.Записать();
		
		ОбновитьСписки(ЭтаФорма, Истина, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписки(Форма, СпискиСотрудников, СпискиДокументов)
	
	Если  СпискиСотрудников Тогда
		Форма.Элементы.СотрудникиБезОтношений.Обновить();
		Форма.Элементы.СотрудникиСОшибками.Обновить();
	КонецЕсли;
	
	Если СпискиДокументов Тогда
		Форма.Элементы.КадровыеПриказыСотрудника.Обновить();
		Форма.Элементы.КадровыеПриказыЗавершенные.Обновить();
		Форма.Элементы.КадровыеПриказыНеПроведенные.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция Справки2НДФЛ(Знач Сотрудник)
	
	ВозвращаемаяСтруктура = Новый Структура("ФизическоеЛицо,Организация,Справки2НДФЛ", , , Новый СписокЗначений);
	
	Запрос = Новый Запрос;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, "ФизическоеЛицо,ТекущаяОрганизация");
	
	ВозвращаемаяСтруктура.ФизическоеЛицо = КадровыеДанные[0].ФизическоеЛицо;
	ВозвращаемаяСтруктура.Организация = КадровыеДанные[0].ТекущаяОрганизация;
	
	Запрос.УстановитьПараметр("Сотрудник", ВозвращаемаяСтруктура.ФизическоеЛицо);
	Запрос.УстановитьПараметр("Организация", ВозвращаемаяСтруктура.Организация);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправкаНДФЛ.Ссылка
		|ПОМЕСТИТЬ ВТВсеСправки
		|ИЗ
		|	Документ.СправкаНДФЛ КАК СправкаНДФЛ
		|ГДЕ
		|	СправкаНДФЛ.Сотрудник = &Сотрудник
		|	И СправкаНДФЛ.Организация = &Организация
		|	И НЕ СправкаНДФЛ.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеСправки.Ссылка.НалоговыйПериод КАК НалоговыйПериод
		|ПОМЕСТИТЬ ВТНалоговыеПериоды
		|ИЗ
		|	ВТВсеСправки КАК ВсеСправки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НалоговыеПериоды.НалоговыйПериод,
		|	МАКСИМУМ(ВсеСправки.Ссылка.Дата) КАК Дата
		|ПОМЕСТИТЬ ВТДатыПоследнихСправокВПериоде
		|ИЗ
		|	ВТНалоговыеПериоды КАК НалоговыеПериоды,
		|	ВТВсеСправки КАК ВсеСправки
		|
		|СГРУППИРОВАТЬ ПО
		|	НалоговыеПериоды.НалоговыйПериод
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДатыПоследнихСправокВПериоде.НалоговыйПериод КАК НалоговыйПериод,
		|	МАКСИМУМ(ВсеСправки.Ссылка) КАК Ссылка
		|ИЗ
		|	ВТДатыПоследнихСправокВПериоде КАК ДатыПоследнихСправокВПериоде
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеСправки КАК ВсеСправки
		|		ПО ДатыПоследнихСправокВПериоде.Дата = ВсеСправки.Ссылка.Дата
		|
		|СГРУППИРОВАТЬ ПО
		|	ДатыПоследнихСправокВПериоде.НалоговыйПериод
		|
		|УПОРЯДОЧИТЬ ПО
		|	НалоговыйПериод УБЫВ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВозвращаемаяСтруктура.Справки2НДФЛ.Добавить(Выборка.Ссылка, Выборка.НалоговыйПериод);
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

&НаКлиенте
Функция СотрудникЗаполнен()
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru='Выберите сотрудника'"));
		Возврат Ложь;
		
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
